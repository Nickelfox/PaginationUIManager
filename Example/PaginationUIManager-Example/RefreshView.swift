//
//  RefreshView.swift
//  PaginationUIManager-Example
//
//  Created by Vaibhav Parmar on 07/09/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit
import PaginationUIManager

class RefreshView: PullToRefreshContentView {
	@IBOutlet var statusLabel: UILabel!
	@IBOutlet var progressLabel: UILabel!
	
	static var newInstance: RefreshView {
		return Bundle.main.loadNibNamed("RefreshView", owner: nil, options: nil)![0] as! RefreshView
	}
	
	public override func setState(_ state: PullToRefreshViewState, with view: PullToRefreshView!) {
		switch state {
		case .normal, .closing:
			self.statusLabel.text = nil
		case .ready:
			self.statusLabel.text = "Ready"
		case .loading:
			self.statusLabel.text = "Loading"
		}
	}
	
	
	public  override func setPullProgress(_ pullProgress: CGFloat) {
		progressLabel.text = String(describing: pullProgress)
	}
	
}
