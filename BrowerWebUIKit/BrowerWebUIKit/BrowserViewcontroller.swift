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
    
    /// Properties
    private var provider = LPMetadataProvider()
    var updatedUrlArray = [String]()
    var isAllTabsSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Custom Method
    fileprivate func setupView() {
        addBtnBottomConstraint.constant = -74
        updatedUrlArray.append("https://www.google.com/search?q=")
        browserCollectionView.isScrollEnabled = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let cell = browserCollectionView.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserCollectionViewCell
        if keyPath == "title" {
            let oldValue: NSObject? = change?[.oldKey] as? NSObject
            let newValue: NSObject? = change?[.newKey] as? NSObject
            if oldValue != newValue {
                cell?.thumbnailLabel.text = change?[.newKey] as? String
            }
//            DispatchQueue.main.async {
//                cell?.thumbnailLabel.text = change?[.newKey] as? String
//
//            }
        }
    }
    

    func closeButnTapped(_ index: Int) {
        self.updatedUrlArray.remove(at: index)
        browserCollectionView.reloadData()
    }
    
    // MARK: - Action Methods
    @IBAction func openAllTabs(_ sender: Any) {
        isAllTabsSelected = true
        self.browserCollectionView.reloadData()
        addBtnBottomConstraint.constant = 34
    }
    
    @IBAction func addButnTapped(_ sender: Any) {
        let cell = browserCollectionView.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserCollectionViewCell
        browserCollectionView.isScrollEnabled = true
        updatedUrlArray.insert("https://www.google.com/search?q=", at: cell?.deleteButton.tag ?? 0)
//        updatedUrlArray.append("https://www.google.com/search?q=")
        self.browserCollectionView.reloadData()
    }

    @IBAction func fwdBtn(_ sender: Any) {
        let cell = browserCollectionView.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserCollectionViewCell
        if cell != nil {
            if cell?.thumbnailWebView.canGoForward == true {
                cell?.thumbnailWebView.goForward()
            }
        }
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        let cell = browserCollectionView.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserCollectionViewCell
        if cell != nil {
            cell?.thumbnailWebView.reload()
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        let cell = browserCollectionView.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserCollectionViewCell
        if cell != nil {
            if cell?.thumbnailWebView.canGoBack == true {
                cell?.thumbnailWebView.goBack()
            }
        }
    }
  
    // MARK: - UITextField Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cell = browserCollectionView.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserCollectionViewCell
        var urlString: String = textField.text!
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: urlString, options: [], range: NSRange(location: 0, length: urlString.utf16.count))
        var urlChecker = ""
        for match in matches {
            guard let range = Range(match.range, in: urlString) else { continue }
            let url = urlString[range]
            urlChecker.append(contentsOf: url)
        }
         if updatedUrlArray.count > 0 {
             updatedUrlArray.remove(at: (cell?.deleteButton.tag)!)
         }
        if urlChecker == "" {
            urlString = urlString.replacingOccurrences(of: " ", with: "+")
            let url = URL(string: "https://www.google.com/search?q=\(urlString)")
            self.searchTextField.text = url?.absoluteString
            cell?.thumbnailLabel.text = textField.text
            updatedUrlArray.insert(url!.absoluteString, at: (cell?.deleteButton.tag)!)
        } else {
            self.searchTextField.text = urlChecker
            cell?.thumbnailLabel.text = textField.text
            updatedUrlArray.insert(urlChecker, at: (cell?.deleteButton.tag)!)
        }
        cell?.thumbnailLabel.text = cell?.thumbnailWebView.url?.absoluteString
        browserCollectionView.reloadData()
        return true
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return updatedUrlArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowserCollectionViewCell", for: indexPath) as! BrowserCollectionViewCell
        cell.thumbnailWebView.navigationDelegate = self
        cell.loadURLOnWebView(updatedUrlArray[indexPath.row])
        cell.delegate = self
        cell.deleteButton.tag = indexPath.item
        cell.thumbnailWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    
        if isAllTabsSelected {
            let view = UIView(frame: CGRect(x: 0, y: 30, width: (collectionView.frame.size.width / 2) - 20, height: (collectionView.frame.size.height / 2) - 20))
            view.backgroundColor = .clear
            cell.addSubview(view)
            cell.thumbnailView.isHidden = false
            cell.thumnailViewHeight.constant = 40
//            let link = updatedUrlArray[0]
//
//            // Re-create the provider
//            provider = LPMetadataProvider()
//
//            let url = URL(string: link)!
//
//            // Start fetching metadata
//            provider.startFetchingMetadata(for: url) { metadata, error in
//              guard
//                let metadata = metadata,
//                error == nil
//                else { return }
//
//              // Use the metadata
//               DispatchQueue.main.async {
//                    cell.thumbnailLabel.text = metadata.title ?? "Google Search"
//               }
//           }
            
    
        } else {
            cell.thumbnailView.isHidden = true
            cell.thumnailViewHeight.constant = 0
            
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedURL = updatedUrlArray[indexPath.row]
        if let index = updatedUrlArray.firstIndex(of: selectedURL) {
            updatedUrlArray.remove(at: index)
            updatedUrlArray.insert(selectedURL, at: index)
            isAllTabsSelected = false
            addBtnBottomConstraint.constant = -74
        }
        self.browserCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isAllTabsSelected {
            return CGSize(width: (collectionView.frame.size.width / 2) - 20, height: (collectionView.frame.size.height / 2) - 20)
        } else {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if isAllTabsSelected {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
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
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let cell = browserCollectionView.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserCollectionViewCell

        if cell != nil {

            if let url = navigationAction.request.url {
//                    print(url.absoluteString) // It will give the selected link URL
                if let index = cell?.deleteButton.tag {
                    updatedUrlArray.remove(at: index)
                    updatedUrlArray.insert(url.absoluteString, at: index)
                    searchTextField.text = url.absoluteString
                }

            }
            decisionHandler(.allow)
        }
    }
    
    
}

