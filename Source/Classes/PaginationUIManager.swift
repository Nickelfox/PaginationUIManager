//
//  PaginationUIManager-Example.swift
//  PaginationUIManager-Example
//
//  Created by Ravindra Soni on 07/09/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import SSPullToRefresh

public protocol PaginationUIManagerDelegate {
	func refreshAll(completion: @escaping (_ hasMoreData: Bool) -> Void)
	func loadMore(completion: @escaping (_ hasMoreData: Bool) -> Void)
}

public enum PullToRefreshType {
	case none
	case basic
    case custom(top: PullToRefreshContentView?, bottom: UIView?)
}

public class PaginationUIManager: NSObject {
	fileprivate weak var scrollView: UIScrollView?
	fileprivate var refreshControl: UIRefreshControl?
	fileprivate var bottomLoader: UIView?
	fileprivate var isObservingKeyPath: Bool = false
	fileprivate var pullToRefreshView: PullToRefreshView?
    fileprivate var bottomLoaderView: UIView?
	
	public var delegate: PaginationUIManagerDelegate?
	
	fileprivate var pullToRefreshType: PullToRefreshType {
		didSet {
			self.setupPullToRefresh()
		}
	}
	fileprivate var pullToRefreshContentView: UIView? = nil
	
	var isLoading = false
	var hasMoreDataToLoad = true
	
	public init(scrollView: UIScrollView, pullToRefreshType: PullToRefreshType = .basic) {
		self.scrollView = scrollView
		self.pullToRefreshType = pullToRefreshType
		super.init()
		self.setupPullToRefresh()
	}
	
	deinit {
		self.removeScrollViewOffsetObserver()
	}
	
	public func load(completion: @escaping () -> Void) {
		self.refresh {
			completion()
		}
	}
	
	public func endLoading() {
		self.isLoading = false
		self.endRefreshing()
		self.removeBottomLoader()
	}

}

extension PaginationUIManager {
	fileprivate func setupPullToRefresh() {
        setRefreshControllAccording(toTheType: self.pullToRefreshType)
	}
    
    fileprivate func setRefreshControllAccording(toTheType type: PullToRefreshType) {
        switch type {
        case .none:
            self.removeRefreshControl()
            self.removeCustomPullToRefreshView()
        case .basic:
            self.removeCustomPullToRefreshView()
            self.addRefreshControl()
        case .custom(let topView, let bottomView):
            if let topView = topView {
                self.removeRefreshControl()
                self.addCustomPullToRefreshView(topView)
            } else {
                setRefreshControllAccording(toTheType: .none)
            }
            
            self.bottomLoaderView = bottomView
        }
    }
	
	fileprivate func addRefreshControl() {
		self.refreshControl = UIRefreshControl()
		self.scrollView?.addSubview(self.refreshControl!)
		self.refreshControl?.addTarget(
			self,
			action: #selector(PaginationUIManager.handleRefresh),
			for: .valueChanged)
	}
	
	fileprivate func addCustomPullToRefreshView(_ contentView: PullToRefreshContentView) {
		guard  let scrollView = self.scrollView  else { return }
		self.pullToRefreshView = PullToRefreshView(scrollView: scrollView, delegate: self)
		self.pullToRefreshView?.contentView = contentView
	}
	
	fileprivate func removeRefreshControl() {
		self.refreshControl?.removeTarget(
			self,
			action: #selector(PaginationUIManager.handleRefresh),
			for: .valueChanged)
		self.refreshControl?.removeFromSuperview()
		self.refreshControl = nil
	}
	
	fileprivate func removeCustomPullToRefreshView() {
		self.pullToRefreshView = nil
	}
	
	@objc fileprivate func handleRefresh() {
		self.refresh {
			
		}
	}
	
	fileprivate func refresh(completion: @escaping () -> Void) {
		if self.isLoading {
			self.endRefreshing()
			return
		}
		self.isLoading = true
		self.delegate?.refreshAll(completion: { [weak self] hasMoreData in
			guard let this = self else { return }
			this.isLoading = false
			this.hasMoreDataToLoad = hasMoreData
			this.endRefreshing()
			if hasMoreData {
				this.addScrollViewOffsetObserver()
                this.addBottomLoader(fromView: self?.bottomLoaderView)
			}
			completion()
		})
	}
	
	fileprivate func endRefreshing() {
		self.refreshControl?.endRefreshing()
		self.pullToRefreshView?.finishLoading()
	}
}

extension PaginationUIManager {
    fileprivate func addBottomLoader(fromView bottomView: UIView?) {
		guard let scrollView = self.scrollView else { return }
        
        var bottomLoaderView: UIView?
        if let bottomView = bottomView {
            bottomView.frame = getRectForBottomLoader(inScrollView: scrollView)
            bottomLoaderView = bottomView
        } else {
            bottomLoaderView = getDefaultBottomLoader(inScrollView: scrollView)
        }
        
		self.bottomLoader = bottomLoaderView
        scrollView.contentInset.bottom = bottomLoaderView?.frame.height ?? 0
	}
    
    fileprivate func getDefaultBottomLoader(inScrollView scrollView: UIScrollView) -> UIView {
        
        let view = UIView()        
        view.frame = getRectForBottomLoader(inScrollView: scrollView)
        view.backgroundColor = UIColor.clear
        let activity = UIActivityIndicatorView(style: .gray)
        activity.frame = view.bounds
        activity.startAnimating()
        view.addSubview(activity)
        
        return view
    }
    
    fileprivate func getRectForBottomLoader(inScrollView scrollView: UIScrollView) -> CGRect {
        let size = CGSize(width: scrollView.frame.width, height: 60)
        let origin = CGPoint(x: 0, y: scrollView.contentSize.height)
        
        return CGRect(origin: origin, size: size)
    }
	
	fileprivate func showBottomLoader() {
		guard let scrollView = self.scrollView, let loader = self.bottomLoader else { return }
		scrollView.addSubview(loader)
	}
	
	fileprivate func hideBottomLoader() {
		self.bottomLoader?.removeFromSuperview()
	}
	
	fileprivate func removeBottomLoader() {
		self.bottomLoader?.removeFromSuperview()
		self.scrollView?.contentInset.bottom = 0
	}
	
	func addScrollViewOffsetObserver() {
		if self.isObservingKeyPath { return }
		self.scrollView?.addObserver(
			self,
			forKeyPath: "contentOffset",
			options: [.new],
			context: nil)
		self.isObservingKeyPath = true
	}
	
	func removeScrollViewOffsetObserver() {
		if self.isObservingKeyPath {
			self.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
		}
		self.isObservingKeyPath = false
	}
	
	override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard let object = object as? UIScrollView, let keyPath = keyPath, let newValue = change?[.newKey] as? CGPoint else { return }
		if object == self.scrollView && keyPath == "contentOffset" {
			self.setContentOffSet(newValue)
		}
	}
	
	fileprivate func setContentOffSet(_ offset: CGPoint) {
		guard let scrollView = self.scrollView else { return }
		self.bottomLoader?.frame.origin.y = scrollView.contentSize.height
		if !scrollView.isDragging && !scrollView.isDecelerating  { return }
		if self.isLoading || !self.hasMoreDataToLoad { return }
		let offsetY = offset.y
		if offsetY >= scrollView.contentSize.height - scrollView.frame.size.height {
			self.isLoading = true
			self.showBottomLoader()
			self.delegate?.loadMore(completion: { [weak self] hasMoreData in
				guard let this = self else { return }
				this.hideBottomLoader()
				this.isLoading = false
				this.hasMoreDataToLoad = hasMoreData
				if !hasMoreData {
					this.removeBottomLoader()
					this.removeScrollViewOffsetObserver()
				}
			})
		}
	}
}

extension PaginationUIManager: PullToRefreshViewDelegate {
	public func pull(toRefreshViewDidStartLoading view: PullToRefreshView!) {
		self.load { }
		self.pullToRefreshView?.finishLoading()
	}
	
	public func pull(toRefreshViewDidFinishLoading view: PullToRefreshView!) {
		self.endRefreshing()
	}
	
	public func pull(toRefreshViewShouldStartLoading view: SSPullToRefreshView!) -> Bool {
		return true
	}
	
	public func pull(_ view: SSPullToRefreshView!, didUpdateContentInset contentInset: UIEdgeInsets) {
		if self.hasMoreDataToLoad {
			if let bottomLoader = self.bottomLoader {
				self.scrollView?.contentInset.bottom = bottomLoader.frame.height
			}
		}
	}
	
	public func pull(_ view: SSPullToRefreshView!, didTransitionTo toState: SSPullToRefreshViewState, from fromState: SSPullToRefreshViewState, animated: Bool) {
		
	}
	
	public func pull(_ view: SSPullToRefreshView!, willTransitionTo toState: SSPullToRefreshViewState, from fromState: SSPullToRefreshViewState, animated: Bool) {
		
	}
}
