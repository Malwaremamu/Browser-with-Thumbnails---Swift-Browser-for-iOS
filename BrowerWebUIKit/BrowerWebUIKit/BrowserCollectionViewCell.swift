//
//  BrowserCollectionViewCell.swift
//  BrowerWebUIKit
//
//  Created by Boyanapalli, Uday on 3/27/21.
//

import UIKit
import WebKit

protocol BrowseCollectionDelegate: NSObjectProtocol {
    func closeButnTapped(_ index: Int)
}

class BrowserCollectionViewCell: UICollectionViewCell {
    
    /// Properties
    @IBOutlet weak var thumbnailView: UIView!
    
    @IBOutlet weak var thumnailViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var thumbnailLabel: UILabel!
    
    @IBOutlet weak var thumbnailWebView: WKWebView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: BrowseCollectionDelegate?
    // MARK: - Custom Methods

    func loadURLOnWebView(_ url: String) {
        let url = URL(string: url)!
        thumbnailWebView.load(URLRequest(url: url))
        thumbnailWebView.allowsBackForwardNavigationGestures = true
    }
    @IBAction func trashButtonTapped(_ sender: Any) {
        self.delegate?.closeButnTapped(deleteButton.tag)
       
    }
}

