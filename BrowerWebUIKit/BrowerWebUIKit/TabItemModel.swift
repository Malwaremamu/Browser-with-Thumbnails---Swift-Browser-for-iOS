//
//  TabItemModel.swift
//  BrowerWebUIKit
//
//  Created by Boyanapalli, Uday on 4/1/21.
//

import Foundation

class TabItemModel {
    
    var index: Int = 0
    var urlArray: [String]?
    var currentUrl: String = ""
    
    init(index: Int, url: String) {
        self.index = index
        self.urlArray = [url]
        self.currentUrl = url
        
    }
    
    func canGoBack() -> Bool {
        if (index - 1) >= 0  {
            return true
        }
        return false
    }
    
    func goBack() {
        if (canGoBack()) {
            index = index - 1
            currentUrl = urlArray?[index] ?? ""
        }
    }
    
    func canGoFwd() -> Bool {
        if (index + 1) < urlArray?.count ?? 0  {
            return true
        }
        return false
    }
    
    func goFwd() {
        if (canGoFwd()) {
            index = index + 1
            currentUrl = urlArray?[index] ?? ""
        }
    }
    
    func updateTabItem(url: String) {
        if isUrlExist(url: url) {
            print("URL already  exists")
        } else {
            index = index + 1
            currentUrl = url
            urlArray?.append(url)
            print("urlArray: \(String(describing: urlArray)) ")
            print("CurrentUrl: \(currentUrl)")
        }
       
    }
    func isUrlExist(url: String) -> Bool{
        if url == "about:blank" {
            return true
        }
        guard let isContains = self.urlArray?.contains(url) else { return false }
        if isContains {
            return true
        }
        return false
    }
   
    
}
