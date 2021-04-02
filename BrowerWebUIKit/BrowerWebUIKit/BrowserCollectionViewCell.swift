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

    func loadURLOnWebView(tabItem: TabItemModel) {
        let url = URL(string: tabItem.currentUrl)!
        thumbnailWebView.load(URLRequest(url: url))
        thumbnailWebView.allowsBackForwardNavigationGestures = true
        thumbnailLabel.text = url.host
    }
    @IBAction func trashButtonTapped(_ sender: Any) {
        self.delegate?.closeButnTapped(deleteButton.tag)
       
    }
}
extension BrowserCollectionViewCell: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // setting hieght of view according ot content height of the webview
        webView.scrollView.isScrollEnabled = true
        var frame = webView.frame
        frame.size.height = 1
        webView.frame = frame
        frame.size.height = webView.scrollView.contentSize.height
        webView.frame = frame
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)

    }
    
    
}

