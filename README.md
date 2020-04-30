[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/Nickelfox/FormValidation/blob/master/LICENSE.md)
![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)

PaginationUIManager
============
**PaginationUIManager** is a quite handy library for pagination in iOS. It also offers custom PullToRefresh View.

Features
------------
 - Ease to implement Pagination.
 - Choise of using custom refreshing animation for pull-to-refresh or basic (default provided by iOS).
 - Bottom loader (if there is more data to load) is automatically managed.

Installation
------------------
#### <i class="icon-file"></i>**CocoaPods**
[CocoaPods](https://cocoapods.org) is the dependency manager for Cocoa Libraries. You can install Cocoapods using following command:

> `$ sudo gem install cocoapods`

If you wish to integrate PaginationUIManager in your project, the make following changes in your `Podfile`:

    source 'https://github.com/Nickelfox/PaginationUIManager.git'
    platform :ios, '9.0'
    use_frameworks!
    pod 'PaginationUIManager', '~> 0.2.1'
After saving `Podfile`. Run following command:

    pod install

#### <i class="icon-pencil"></I>**Manually**
If you don't want to use any dependency manager in your project, you can install this library manually too.
Just add the following lines to your `Podfile`:

    pod "PaginationUIManager", :git => 'https://github.com/Nickelfox/PaginationUIManager.git'

After saving Podfile, run following:

     pod install

Usage
---------
It's very simple to use PaginationUIManager. What all you need is just to create a variable of type **PaginationUIManager**.

    fileprivate var paginationUIManager: PaginationUIManager?
    
While initialising, PaginationUIManager requires the UIScrollView(or its subclasses i.e. UITableView or UICollectionView) and pullToRefreshView type e.g. none, basic or custom. The custom type accepts the instance of UIView.

```swift
    self.paginationUIManager = PaginationUIManager(scrollView: self.tableView, pullToRefreshType: .basic)
```

Also, we need to set the delegate of **paginationUIManager**.

```swift
    self.paginationUIManager?.delegate = self
```

The ViewController in which we're initialising PaginationUIManager, it must conform **PaginationUIManagerDelegate**.

```swift
    extension ViewController: PaginationUIManagerDelegate {
    		func refreshAll(completion: @escaping (Bool) -> Void) {
    				// your implementation.
    		}
    	
    	func loadMore(completion: @escaping (Bool) -> Void) {
    		// your implementation.
    	}
    }
 ```
 `refreshAll` method is fired when you pull-to-refresh for new data.
  `loadMore` method is fired if there is more data to load.
  
  For custom animations in pull-to-refresh, the UIView class must be subclass of **PullToRefreshContentView**.

method `setState` lets you mange animation of following states.

states are the cases of enum **PullToRefreshViewState**.

```swift
    public enum SSPullToRefreshViewState : UInt {
        // state before you start dragging to refresh
        case normal
        // state when you've dragged enough to refresh
        case ready
        // state when data is getting refreshed
        case loading
        // state when data has finished loading
        case closing
    }
```
If you're using this on `UICollectionView`, then make sure you've enabled paging and set `alwaysBounceVertical` property 
of `UICollectionView` to `true`.


Example
-----------
Detailed example is there in Demo Directory.

Want to Contribute ?
-----------------------------

 - Fork it 
 - Create your feature branch `git checkout -b my-new-feature`
 - Commit your changes `git commit -am 'Add some feature'`
 - Push to the branch `git push origin my-new-feature`  
 - Create a new Pull Request
