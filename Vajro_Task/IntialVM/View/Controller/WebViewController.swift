//
//  WebViewController.swift
//  Vajro_Task
//
//  Created by Sethuram Vijayakumar on 26/05/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!
    var htmlString = String()
    var intialVM : IntialVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialLoads()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
}


extension WebViewController {
    
    func intialLoads(){
        self.intialVM = IntialVM(vc: self)
        self.webViewSetup()
        self.intialVM?.loadHtmlData(str: htmlString)
    }
    
    func webViewSetup() {
        webView = WKWebView()
        view = webView
    }
    private func setNavigationBar(){
        self.title = "Blog Articles"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .red
    }
    
}
