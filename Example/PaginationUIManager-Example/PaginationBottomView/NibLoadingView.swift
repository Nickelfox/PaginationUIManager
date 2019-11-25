//
//  NibLoadingView.swift
//  PaginationUIManager-Example
//
//  Created by Nikolay Dementiev on 25.11.2019.
//  Copyright © 2019 Nickelfox. All rights reserved.
//

import UIKit

protocol NibDefinable {
    var nibName: String { get }
}

@IBDesignable
class NibLoadingView: UIView, NibDefinable {
    
    @IBOutlet weak var view: UIView!
    
    var nibName: String {
        return String(describing: type(of: self))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}

