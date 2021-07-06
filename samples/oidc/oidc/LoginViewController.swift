//
//  LoginViewController.swift
//  oidc
//
//  Created by Craig Pearson on 18/10/19.
//  Copyright © 2019 Craig Pearson. All rights reserved.
//

import UIKit
import WebKit
import IBMVerifyKit

class LoginViewController : UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    
    var authorizeUri = ""
    var tokenUri = ""
    var clientId = ""
    var clientSecret = ""
    
    var hostname = "" {
        didSet {
            authorizeUri = "https://\(hostname)/oidc/endpoint/default/authorize"
            tokenUri = "https://\(hostname)/oidc/endpoint/default/token"
        }
    }
    
    var authorizationDelegate: AuthorizationDelegate?
    
    // MARK: Control variables
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authorizeUrl = URL(string: "\(authorizeUri)?client_id=\(clientId)&response_type=code&scope=openid&redirect_uri=oidc://callback")!
        let request = URLRequest(url: authorizeUrl)
        
        webView.load(request)
    }
    
    // MARK: WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url, url.scheme == "oidc" else {
            decisionHandler(.allow)
            return
        }
        
        print("URL: \(url)")
        
        if let code = url.getQueryString(parameter: "code"), let tokenUrl = URL(string: tokenUri) {
            // Exchange the AZN for an OAuth token.
            OAuthContext.shared.clientSecret = clientSecret
            OAuthContext.shared.authorize(tokenUrl, clientId, code: code, parameters: ["redirect_uri": "oidc://callback"]) {
                token, error  in
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.authorizationDelegate?.onComplete(result: (token: token, error: error))
                    }
                }
            }
        }
        
        decisionHandler(.allow)
    }
}

extension URL {
    func getQueryString(parameter: String) -> String? {
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first { $0.name == parameter }?
            .value
    }
}
