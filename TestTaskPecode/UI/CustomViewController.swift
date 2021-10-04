//
//  CustomViewController.swift
//  TestTaskPecode
//
//  Created by Petro on 01.10.2021.
//

import UIKit
import WebKit

class CustomViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    var cellURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: self.cellURL!)
        self.webView.load(myRequest)
    }
    
//    init(cellURL: URL) {
//        self.cellURL = cellURL
//        super.init(nibName: nil, bundle: nil)
//    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
}
