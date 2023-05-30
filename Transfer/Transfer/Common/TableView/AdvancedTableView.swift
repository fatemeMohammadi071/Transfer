//
//  AdvancedTableView.swift
//  Transfer
//
//  Created by Fateme on 2023-05-26.
//

import UIKit

class AdvancedTableView: UITableView {
    var emptyMessageText: String? {
        didSet {
            emptyDataView.title = emptyMessageText ?? "Nothing here. Pull down to refresh"
        }
    }

    var _refreshControl = UIRefreshControl()

    private lazy var infinityScroll: InfinityScroll = {
        let infinityScroll = InfinityScroll()
        infinityScroll.setup(scrollView: self)
        return infinityScroll
    }()

    private lazy var emptyDataView: EmptyDataView! = {
        let emptyView = EmptyDataView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()

    private var isEmpty: Bool {
        var sections = 1
        guard let dataSource = self.dataSource else { return true }

        if dataSource.responds(to: #selector(UITableViewDataSource.numberOfSections)) {
            sections = dataSource.numberOfSections!(in: self)
        }

        guard dataSource.responds(to: #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))) else { return true }
        for i in 0 ..< sections {
            if dataSource.tableView(self, numberOfRowsInSection: i) > 0 { return false }
        }
        return true
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupTableView()
        addSubview(emptyDataView)
        NSLayoutConstraint.activate([
            emptyDataView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyDataView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyDataView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyDataView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    func updateEmptyDataSetIfNeeded() {
        emptyDataView.isHidden = !isEmpty
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

    override func reloadData() {
        updateEmptyDataSetIfNeeded()
        super.reloadData()
    }

    private func setupTableView() {
        tableFooterView = UIView(frame: .zero)
        rowHeight = UITableView.automaticDimension
        sectionHeaderHeight = UITableView.automaticDimension
    }

    func addInfinityScroll(withDetectionBoundary boundary: CGFloat, delegate: InfinityScrollDelegate) {
        infinityScroll.enabled = true
        infinityScroll.detectionBoundary = boundary
        infinityScroll.delegate = delegate
    }

    func endInfinityScroll() {
        infinityScroll.endInfinityScroll()
    }
}
