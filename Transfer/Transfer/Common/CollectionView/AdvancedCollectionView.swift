//
//  AdvancedCollectionView.swift
//  Github
//
//  Created by Fateme on 2022-11-11.
//

import UIKit

class AdvancedCollectionView: UICollectionView {
    var emptyMessageText: String? {
        didSet {
            emptyDataView.title = emptyMessageText ?? "Nothing here. Pull down to refresh"
        }
    }

    lazy var _refreshControl = UIRefreshControl()

    private lazy var emptyDataView: EmptyDataView! = {
        let emptyView = EmptyDataView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()

    private var isEmpty: Bool {
        var sections = 1

        guard let dataSource = self.dataSource else { return true }
        if dataSource.responds(to: #selector(UICollectionViewDataSource.numberOfSections)) {
            sections = dataSource.numberOfSections!(in: self)
        }

        guard dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:numberOfItemsInSection:))) else { return true }
        for i in 0 ..< sections {
            if dataSource.collectionView(self, numberOfItemsInSection: i) > 0 { return false }
        }

        return true
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func addPullToRefresh(target: Any? = nil, selector: Selector) {
        if #available(iOS 13, *) {
            self.refreshControl = _refreshControl
            self.refreshControl?.addTarget(target, action: selector, for: .valueChanged)
        } else {
            _refreshControl.addTarget(target, action: selector, for: .valueChanged)
            self.addSubview(_refreshControl)
        }
    }

    func beginRefresh() {
        _refreshControl.beginRefreshing()
    }

    func endRefresh() {
        _refreshControl.endRefreshing()
    }

    func updateEmptyDataSetIfNeeded() {
        emptyDataView.isHidden = !isEmpty
    }

    override func reloadData() {
        updateEmptyDataSetIfNeeded()
        super.reloadData()
    }

    private func commonInit() {
        alwaysBounceVertical = true
        addSubview(emptyDataView)
        NSLayoutConstraint.activate([
            emptyDataView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyDataView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyDataView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyDataView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}
