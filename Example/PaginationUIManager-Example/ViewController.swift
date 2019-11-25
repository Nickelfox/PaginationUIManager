//
//  ViewController.swift
//  PaginationUIManager-Example
//
//  Created by Ravindra Soni on 07/09/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit
import PaginationUIManager

public func delay(_ delay:Double, closure:@escaping ()->()) {
	DispatchQueue.main.asyncAfter(
		deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

fileprivate let cellIdentifier = "tableCell"
class ViewController: UIViewController {

	@IBOutlet var tableView: UITableView!
	fileprivate var paginationUIManager: PaginationUIManager?

	fileprivate var items: [Int] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupPagination()
		fetchItems()
	}
	
	fileprivate func setupPagination() {
		paginationUIManager = PaginationUIManager(scrollView: self.tableView, pullToRefreshType: .custom(RefreshView.newInstance))
		paginationUIManager?.delegate = self
	}
	
	fileprivate func fetchItems() {
		paginationUIManager?.load { 
			
		}
	}
	
	fileprivate func handleDataLoad(items: [Int]) {
		self.items.removeAll()
		self.items = items
		self.tableView.reloadData()
	}
	
	fileprivate func handleMoreDataLoad(items: [Int]) {
		self.items.append(contentsOf: items)
		self.tableView.reloadData()
	}
}

//MARK: UITableView DataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
	
	fileprivate func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
		cell.textLabel?.text = String(items[indexPath.row])
		return cell
	}
}

//MARK: Pagination Manager 

extension ViewController: PaginationUIManagerDelegate {
	func refreshAll(completion: @escaping (Bool) -> Void) {
		delay(3) {
			self.handleDataLoad(items: [1,2,3,4,5])
			completion(true)
		}
	}
	
	func loadMore(completion: @escaping (Bool) -> Void) {
		delay(3) {
			self.handleMoreDataLoad(items: [1,2,3,4,5])
			let shouldLoadMore = self.items.count < 15
			completion(shouldLoadMore)
		}
	}
}
