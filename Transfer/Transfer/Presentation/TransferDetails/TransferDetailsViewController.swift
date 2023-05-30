//
//  TransferListViewController.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import UIKit
import Combine

protocol TransferDetailsViewControllerProtocol: AnyObject {
    func viewWillDisAppear(transfer: TransferData?)
}

class TransferDetailsViewController: UIViewController {

    private let stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()

    private let stackViewLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 40
        stackView.alignment = .center
        return stackView
    }()

    private let numberOfTransfersBadgeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Number Of Transfers"
        return label
    }()

    private let totalTransferBadgeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Total Transfer"
        return label
    }()

    private let stackViewCounters: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 40
        stackView.alignment = .center
        return stackView
    }()

    private let numberOfTransfersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private let totalTransferLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private let noteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private var favButton: UIButton = {
        let button = UIButton()
        return button
    }()

    weak var delegate: TransferDetailsViewControllerProtocol?

    private var transfer: TransferData?

    private var store = Set<AnyCancellable>()

    private let viewModel: TransferDetailsViewModelProtocol

    init(viewModel: TransferDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindToViewModel()
        viewModel.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.viewWillDisAppear(transfer: transfer)
    }

    private func setupViews() {
        view.backgroundColor = .white
        setupStackViewContainer()
        setupImageView()
        setupFavButton()
        setupName()
        setupStackViewLabels()
        setupStackViewCounters()
        setupNoteLabel()
    }

    private func setupStackViewContainer() {
        view.addSubview(stackViewContainer)
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stackViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                                     stackViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
                                     stackViewContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)])
    }

    private func setupImageView() {
        stackViewContainer.addArrangedSubview(imageView)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalToConstant: 70),
                                     imageView.heightAnchor.constraint(equalToConstant: 70)])
    }

    private func setupFavButton() {
        stackViewContainer.addArrangedSubview(favButton)
        favButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([favButton.widthAnchor.constraint(equalToConstant: 50),
                                     favButton.heightAnchor.constraint(equalToConstant: 50)])
        favButton.addTarget(self, action: #selector(favButtonClicked), for: .touchUpInside)
    }

    private func setupName() {
        stackViewContainer.addArrangedSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([nameLabel.centerXAnchor.constraint(equalTo: stackViewContainer.centerXAnchor)])
    }

    private func setupStackViewLabels() {
        stackViewContainer.addArrangedSubview(stackViewLabels)
        stackViewLabels.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stackViewLabels.heightAnchor.constraint(equalToConstant: 28)])
        stackViewLabels.addArrangedSubview(numberOfTransfersBadgeLabel)
        stackViewLabels.addArrangedSubview(totalTransferBadgeLabel)
    }
    
    private func setupStackViewCounters() {
        stackViewContainer.addArrangedSubview(stackViewCounters)
        stackViewCounters.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stackViewCounters.heightAnchor.constraint(equalToConstant: 28),
                                     stackViewCounters.leftAnchor.constraint(equalTo: stackViewLabels.leftAnchor),
                                     stackViewCounters.rightAnchor.constraint(equalTo: stackViewLabels.rightAnchor)])
        stackViewCounters.addArrangedSubview(numberOfTransfersLabel)
        stackViewCounters.addArrangedSubview(totalTransferLabel)
    }

    private func setupNoteLabel() {
        stackViewContainer.addArrangedSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([noteLabel.centerXAnchor.constraint(equalTo: stackViewContainer.centerXAnchor)])
    }

    private func bindToViewModel() {
        viewModel.transfer$.sink { [unowned self] transfer$ in
            self.update(transfer: transfer$)
        }.store(in: &store)

        viewModel.imageData$.sink { [unowned self] data in
            guard let data = data else { return }
            self.imageView.setImage(data)
        }.store(in: &store)
    }
    
    private func displayLoading(isLoading: Bool) {
        if isLoading {
            view.showLoading()
        } else {
            view.hideLoading()
        }
    }

    private func update(transfer: TransferData) {
        self.transfer = transfer
        nameLabel.text = transfer.name
        let numberOfTransfers:String = "\(transfer.moreInfo?.numberOfTransfers ?? 0)"
        let totalTransfer: String = "\(transfer.moreInfo?.totalTransfer ?? 0)"
        numberOfTransfersLabel.text = numberOfTransfers
        totalTransferLabel.text = totalTransfer
        noteLabel.text = transfer.note
        setFavImage(isFav: transfer.isFav ?? false)
    }

    @objc func favButtonClicked() {
        let isFav = transfer?.isFav ?? false
        transfer?.isFav = !isFav
        setFavImage(isFav: !isFav)
    }

    private func setFavImage(isFav: Bool) {
        let image = isFav ? UIImage(named: "fav") : UIImage(named: "unFav")
        favButton.setImage(image, for: .normal)
    }
}
