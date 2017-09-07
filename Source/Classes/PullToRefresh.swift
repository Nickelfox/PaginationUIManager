//
//  PullToRefresh.swift
//  Pods
//
//  Created by Vaibhav Parmar on 07/09/17.
//
//

import SSPullToRefresh

public typealias PullToRefreshView = SSPullToRefreshView
public typealias PullToRefreshViewDelegate = SSPullToRefreshViewDelegate
public typealias PullToRefreshViewStyle = SSPullToRefreshViewStyle
public typealias PullToRefreshViewState = SSPullToRefreshViewState

open class PullToRefreshContentView: UIView, SSPullToRefreshContentView  {
	
	open  func setState(_ state: PullToRefreshViewState, with view: PullToRefreshView!) {
		
	}
	
	open  func setPullProgress(_ pullProgress: CGFloat) {
		
	}
	
	open  func setLastUpdatedAt(_ date: Date!, with view: PullToRefreshView!) {
		
	}
	
}

