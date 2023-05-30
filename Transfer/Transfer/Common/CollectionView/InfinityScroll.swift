//
//  InfinityScroll.swift
//  Transfer
//
//  Created by Fateme on 2023-05-26.
//

import UIKit

protocol InfinityScrollDelegate: AnyObject {
    func scrollViewShouldStartInfiniteScroll(_ scrollView: UIScrollView) -> Bool
    func scrollViewDidStartInfiniteScroll(_ scrollView: UIScrollView)
}

final class InfinityScroll {
    weak var delegate: InfinityScrollDelegate?

    /// A Boolean value that determines whether the `infinityScroll` is enabled. default is `True`
    var enabled: Bool = false

    /// `scrollView` will check this boundary to notify you while scrolling.
    /// `0` is exactly  bottom of `scrollView`
    var detectionBoundary: CGFloat = 1500

    /// The height of the indicator container at the bottom of the scroll view
    var indicatorContainerHeight: CGFloat = 120

    /// The size of the indicator
    var indicatorSize: CGSize = CGSize(width: 30, height: 30)

    private weak var scrollView: UIScrollView?
    private var isLoading: Bool = false
    private var lastContentHeight: CGFloat = 0
    private var lastContentOffset: CGFloat = 0
    private var contentOffsetObservation: NSKeyValueObservation?
    private var bottomInset: CGFloat!
    private lazy var loadMoreIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()

    /// This method must be called once
    func setup(scrollView: UIScrollView) {
        scrollView.addSubview(loadMoreIndicatorView)
        self.scrollView = scrollView
        contentOffsetObservation = scrollView.observe(\.contentOffset, options: [.new]) { [weak self] _, _ in
            guard let self = self else { return }
            self.contentOffsetDidChange()
        }
    }

    /// Call this method when you have loaded the data
    func endInfinityScroll() {
        stopLoading()
    }

    private func contentOffsetDidChange() {

        // First check for infinite scroll to be enabled and value of `isLoading` to be false
        guard enabled, !isLoading,
              let scrollView = scrollView,
              lastContentOffset != scrollView.contentOffset.y else { return }

        let contentOffsetY = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.bounds.height
        let contentSizeHeight = scrollView.contentSize.height

        // Calculate the distance to the end of the scrollView
        let diffYEnd = contentOffsetY + scrollViewHeight - contentSizeHeight

        if scrollViewHeight - contentSizeHeight > -detectionBoundary {
            if diffYEnd >= 0 { startLoading() }
            return
        }

        // Then check for any change in content height.
        guard lastContentHeight != contentSizeHeight else {
            // If there was no change in content offset, try to set value of `lastContentHeight` to 0
            if diffYEnd < -detectionBoundary || contentOffsetY <= 0 { lastContentHeight = 0 }
            return
        }

        // Finally check for the boundary of detection area to start loading
        guard diffYEnd >= -detectionBoundary else { return }

        lastContentHeight = contentSizeHeight
        startLoading()
    }

    private func startLoading() {
        guard let scrollView = scrollView,
              delegate?.scrollViewShouldStartInfiniteScroll(scrollView) ?? false,
              isLoading == false else { return }
        isLoading = true
        loadMoreIndicatorView.frame = CGRect(x: scrollView.bounds.width/2 - indicatorSize.width/2,
                                         y: indicatorContainerHeight/2 + scrollView.contentSize.height - indicatorSize.height/2,
                                         width: indicatorSize.width,
                                         height: indicatorSize.height)

        bottomInset = indicatorContainerHeight
        scrollView.contentInset.bottom += bottomInset
        loadMoreIndicatorView.startAnimating()
        delegate?.scrollViewDidStartInfiniteScroll(scrollView)
    }

    private func stopLoading() {
        guard isLoading == true else { return }
        let bottomInset = bottomInset!
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.scrollView?.contentInset.bottom -= bottomInset
            self?.loadMoreIndicatorView.stopAnimating()
        }
        isLoading = false
    }
}
