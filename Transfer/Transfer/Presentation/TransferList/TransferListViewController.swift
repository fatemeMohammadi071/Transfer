//
//  TransferListViewController.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import UIKit
import Combine

class TransferListViewController: UIViewController {

    private var store = Set<AnyCancellable>()

    lazy var tableView: AdvancedTableView = {
        let view = AdvancedTableView()
        view.delegate = self
        view.dataSource = self
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.register(TransferTableViewCell.self, forCellReuseIdentifier: "TransferTableViewCell")
        view.register(DefaultHeaderTableView.self, forHeaderFooterViewReuseIdentifier: "DefaultHeaderTableView")
        view.rowHeight = UITableView.automaticDimension
        view.backgroundColor = .clear
        view.addInfinityScroll(withDetectionBoundary: 1500, delegate: self)
        return view
    }()

    lazy var collectionView: AdvancedCollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        viewLayout.itemSize = CGSize(width: LayoutConstant.itemHeight, height: LayoutConstant.itemHeight)
        let view = AdvancedCollectionView(frame: .zero, collectionViewLayout: viewLayout)
        view.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        view.backgroundColor = .white
        view.register(FavoriteTransferCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteTransferCollectionViewCell.identifier)
        view.dataSource = self
        view.register(DefaultHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DefaultHeaderCollectionView.identifier)
        return view
    }()

    private enum LayoutConstant {
        static let spacing: CGFloat = 16.0
        static let itemHeight: CGFloat = 100.0
    }

    private var transfers: [TransferData] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var favTransfers: [TransferData] = [] {
        didSet {
            collectionView.reloadData()
            updateCollectionViewHeightConstraint()
        }
    }

    private var collectionHeightConstraint: NSLayoutConstraint?

    private var tableViewTopConstraint: NSLayoutConstraint?

    private let viewModel: TransferListViewModelProtocol

    private let downloadImageUseCase: DownloadImageUseCaseProtocol

    private var currentPage: Int = 1

    private var canLoadMore: Bool = true

    init(viewModel: TransferListViewModelProtocol, downloadImageUseCase: DownloadImageUseCaseProtocol) {
        self.viewModel = viewModel
        self.downloadImageUseCase = downloadImageUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupCollectionViewConstraints()
        setupTableViewConstraints()
        bindToViewModel()
        viewModel.viewDidLoad()
    }
    
    private func configUI() {
        view.backgroundColor = .white
        setupPullToRefresh()
    }
    
    private func setupCollectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let height: CGFloat = favTransfers.isEmpty ? 0 : 100
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: height)
        guard let collectionHeightConstraint else { return }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionHeightConstraint
        ])
    }

    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: collectionHeightConstraint?.constant ?? 0)
        guard let tableViewTopConstraint else { return }
        NSLayoutConstraint.activate([
            tableViewTopConstraint,
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func bindToViewModel() {
        viewModel.error$.sink { [unowned self] error in
            displayError(error: error)
        }.store(in: &store)

        viewModel.isLoading$.sink { [unowned self] isLoading in
            self.displayLoading(isLoading: isLoading)
        }.store(in: &store)

        viewModel.isEmptyList$.sink { [unowned self] in
            self.displayEmptytViewData()
        }.store(in: &store)

        viewModel.items$.sink { [unowned self] transfers in
            self.transfers.append(contentsOf: transfers)
            self.tableView.endRefresh()
        }.store(in: &store)
        
        viewModel.canLoadMore.sink { [unowned self] canLoadMore in
            tableView.endInfinityScroll()
            self.canLoadMore = canLoadMore
        }.store(in: &store)
    }

    private func displayError(error: NetworkError) {
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            guard let currentPage = self?.currentPage, currentPage != 1 else {
                self?.viewModel.viewDidLoad()
                return
            }
            self?.viewModel.loadMoreData(page: currentPage)
        }
        self.presentMessege(title: "Error", message: error.localizedDescription, additionalActions: okAction, retryAction, preferredStyle: .alert)
    }

    private func displayLoading(isLoading: Bool) {
        if isLoading {
            view.showLoading()
        } else {
            view.hideLoading()
        }
    }

    private func displayEmptytViewData() {
        self.tableView.emptyMessageText = "There is no Transfer"
        self.tableView.updateEmptyDataSetIfNeeded()
    }

    private func setupPullToRefresh() {
        tableView.addPullToRefresh(target: self, selector: #selector(refresh))
    }

    @objc private func refresh() {
        clearData()
        tableView.endRefresh()
        viewModel.viewDidLoad()
    }

    private func clearData() {
        canLoadMore = true
        transfers = []
        favTransfers = []
    }

    private func updateCollectionViewHeightConstraint() {
        collectionHeightConstraint?.constant = favTransfers.isEmpty ? 0 : 100
        tableViewTopConstraint?.constant = favTransfers.isEmpty ? 0 : 100
        collectionView.layoutSubviews()
        tableView.layoutSubviews()
        collectionView.reloadData()
    }
}
extension TransferListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transfers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transfer = transfers[safe: indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransferTableViewCell.identifier, for: indexPath) as? TransferTableViewCell else {
            return UITableViewCell()
        }
        cell.bind(transfer, downloadImageUseCase: downloadImageUseCase)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let transfer = (transfers[safe: indexPath.item]) else { return }
        viewModel.didSelectItemWith(transfer)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = DefaultHeaderTableView(reuseIdentifier: "DefaultHeaderTableView")
        view.setTitleLabelWith("All")
        return view
    }
}

extension TransferListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favTransfers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let transfer = favTransfers[safe: indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteTransferCollectionViewCell.identifier, for: indexPath) as? FavoriteTransferCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bind(transfer, downloadImageUseCase: downloadImageUseCase)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = DefaultHeaderCollectionView(frame: .zero)
            view.setTitleLabelWith("Favorite")
            return view
        default:
            return UICollectionReusableView(frame: .zero)
        }
    }
}

extension TransferListViewController: TransferDetailsViewControllerProtocol {
    func viewWillDisAppear(transfer: TransferData?) {
        if let index = transfers.firstIndex(where: { $0.identifier == transfer?.identifier }) {
            transfers[index].isFav = transfer?.isFav
        }
        favTransfers = transfers.filter { $0.isFav ?? false }
    }
}

extension TransferListViewController: InfinityScrollDelegate {
    func scrollViewShouldStartInfiniteScroll(_ scrollView: UIScrollView) -> Bool {
        return canLoadMore
    }
    
    func scrollViewDidStartInfiniteScroll(_ scrollView: UIScrollView) {
        currentPage += 1
        viewModel.loadMoreData(page: currentPage)
    }
}
