//
//  ViewController.swift
//  talya2
//
//  Created by David Blackman on 3/5/19.
//  Copyright © 2019 David Blackman. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet var containerView: UIView!
    var webView: WKWebView?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func loadView() {
        super.loadView()
        
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        webViewConfiguration.suppressesIncrementalRendering = false
        webViewConfiguration.allowsAirPlayForMediaPlayback = true
        webViewConfiguration.mediaTypesRequiringUserActionForPlayback = []
        webViewConfiguration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"

       
        self.webView = WKWebView(frame: self.view.frame, configuration: webViewConfiguration)
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://mixlet.firebaseapp.com")!
        
        let req = URLRequest(url: url)
        self.webView!.navigationDelegate = self
        self.webView!.load(req)
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let newURL = navigationAction.request.url,
                let host = newURL.host , !host.hasPrefix("mixlet") &&
                UIApplication.shared.canOpenURL(newURL) {
                UIApplication.shared.open(newURL, options: [:], completionHandler: nil)
                print(newURL)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                print(navigationAction.request.url)
                print(navigationAction.request.url?.host)
                print(navigationAction.request.url?.host?.hasPrefix("mixlet"))
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

