//
//  FeedWebViewController.swift
//  WSJFeed
//
//  Created by Bhaskar Ghosh on 11/10/20.
//  Copyright © 2020 Bhaskar Ghosh. All rights reserved.
//

import UIKit
import WebKit

class FeedWebViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    
    var webUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = webUrl else {
            return
        }
        
        navigationController?.navigationBar.prefersLargeTitles = false
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    /// Observes the progress as the webpage loads and sets the progress value to  progressView
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    ///Provides an implementation for going back within the webview hierarchy. If there is no webpage to go back to then the ViewController is dismissed
    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            dismiss(animated: true,
                    completion: nil)
        }
    }
    
    deinit {
        webView.removeObserver(self,
                               forKeyPath: "estimatedProgress",
                               context: nil)
    }
}
