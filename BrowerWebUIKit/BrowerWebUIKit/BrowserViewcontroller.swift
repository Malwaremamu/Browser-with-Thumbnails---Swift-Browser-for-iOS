//
//  ViewController.swift
//  BrowerWebUIKit
//
//  Created by Boyanapalli, Uday on 3/27/21.
//

import UIKit
import WebKit
import LinkPresentation

class ViewController: UIViewController, UITextFieldDelegate, BrowseCollectionDelegate {

    /// Outlets
    @IBOutlet weak var browserCollectionView: UICollectionView!
    @IBOutlet weak var addBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fwdButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var browserWebView: WKWebView!
    /// Properties
    private var provider = LPMetadataProvider()
    var arrAllTabs = [TabItemModel]()
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var webViewTag: Int {
        get {
            return browserWebView.tag - 101
        }
        set(newValue) {
            browserWebView.tag = newValue + 101
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewTag = 0
        setupView()
    }
    
    // MARK: - Custom Method
    fileprivate func setupView() {
        addBtnBottomConstraint.constant = -74
        browserCollectionView.isScrollEnabled = false
        let tabItem = TabItemModel(index: 0, url: "https://www.google.com/webhp")
        arrAllTabs.append(tabItem)

//        loadURLOnWebView(updatedUrlArray[0])
        self.openTab(index: 0)
        browserWebView.navigationDelegate = self
        self.showOrHideAllTabs(needsToShow: false)
    }
    
    func loadTabOnWebView(tabItem: TabItemModel) {
        let url = URL(string: tabItem.currentUrl)!
        print("LoadTabOnWebView: \(url)")
        browserWebView.load(URLRequest(url: url))
        browserWebView.allowsBackForwardNavigationGestures = true
    }
    
    func showOrHideAllTabs(needsToShow: Bool) {
        if needsToShow {
            browserWebView.isHidden = true
            browserCollectionView.isHidden = false
            self.view.bringSubviewToFront(browserCollectionView)
        } else {
            browserWebView.isHidden = false
            browserCollectionView.isHidden = true
            self.view.bringSubviewToFront(browserWebView)
        }
    }

//    func addNewTab() {
//
//    }

    func openTab(index: Int) {
        webViewTag = index
        loadTabOnWebView(tabItem: arrAllTabs[index])
    }
    
//    func updateTabData(index: Int, url: String) {
//
//    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        let tag = (object as? WKWebView)?.tag
////        print("Selected Tag : \(String(describing: tag))")
//        let cell = browserCollectionView.cellForItem(at: IndexPath.init(item: tag ?? 0, section: 0)) as? BrowserCollectionViewCell
//
//        if keyPath == "title" {
//            let oldValue: NSObject? = change?[.oldKey] as? NSObject
//            let newValue: NSObject? = change?[.newKey] as? NSObject
//            if oldValue != newValue {
//                cell?.thumbnailLabel.text = change?[.newKey] as? String
//            }
//
//        }
    }

    func closeButnTapped(_ index: Int) {
        self.arrAllTabs.remove(at: index)
        browserCollectionView.reloadData()
    }
    
    // MARK: - Action Methods
    @IBAction func openAllTabs(_ sender: Any) {
        self.showOrHideAllTabs(needsToShow: true)
//        isAllTabsSelected = true
        self.browserCollectionView.reloadData()
        addBtnBottomConstraint.constant = 34
    }
    
    @IBAction func addButnTapped(_ sender: Any) {
        let tabItem = TabItemModel(index: arrAllTabs.count - 1, url: "https://www.google.com/webhp")
        arrAllTabs.append(tabItem)
       
        browserCollectionView.isScrollEnabled = true
        self.browserCollectionView.reloadData()
    }

    @IBAction func fwdBtn(_ sender: Any) {
        let tabItem = self.arrAllTabs[webViewTag]
        if tabItem.canGoFwd() {
            tabItem.goFwd()
            self.loadTabOnWebView(tabItem: tabItem)
        }
        
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        let tabItem = self.arrAllTabs[webViewTag]
        self.loadTabOnWebView(tabItem: tabItem)
    }
    
    @IBAction func backButton(_ sender: Any) {
        let tabItem = self.arrAllTabs[webViewTag]
        if tabItem.canGoBack() {
            tabItem.goBack()
            self.loadTabOnWebView(tabItem: tabItem)
        }
    }
  
    // MARK: - UITextField Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let 
        return true
    }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAllTabs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowserCollectionViewCell", for: indexPath) as! BrowserCollectionViewCell
        cell.thumbnailWebView.navigationDelegate = cell
        
        cell.loadURLOnWebView(tabItem: arrAllTabs[indexPath.row])
        cell.delegate = self
        cell.deleteButton.tag = indexPath.item
        cell.thumbnailWebView.tag = indexPath.item
    
        let view = UIView(frame: CGRect(x: 0, y: 30, width: (collectionView.frame.size.width / 2) - 20, height: (collectionView.frame.size.height / 2) - 20))
        view.backgroundColor = .clear
        cell.addSubview(view)
        cell.thumbnailView.isHidden = false
        cell.thumnailViewHeight.constant = 40

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.openTab(index: indexPath.item)
        self.showOrHideAllTabs(needsToShow: false)
        addBtnBottomConstraint.constant = -74
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width / 2) - 20, height: (collectionView.frame.size.height / 2) - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // setting hieght of view according ot content height of the webview
        webView.scrollView.isScrollEnabled = true
        var frame = webView.frame
        frame.size.height = 1
        webView.frame = frame
        frame.size.height = webView.scrollView.contentSize.height
        webView.frame = frame
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
            let tag = webView.tag - 101
            if (self.arrAllTabs.count > tag && tag > -1)  {
                let tabItem = self.arrAllTabs[tag]
                tabItem.updateTabItem(url: url)
                searchTextField.text = url
                print("WebView url =  \(url)")
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)

    }
    
    
    
}

