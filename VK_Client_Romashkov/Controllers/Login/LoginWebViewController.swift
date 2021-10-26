//
//  LoginWebViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 04.03.2021.
//

import UIKit
import WebKit

final class LoginWebViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Session
    
    let session = Session.instance
    
    // MARK: - Web Service
    
    let VKservice = VKAPIService()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
            webView.load(VKAPIService.getVKAuthorization())
        }
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let parameters = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, parameter in
                var dict = result
                let key = parameter[0]
                let value = parameter[1]
                dict[key] = value
                return dict
            }
        
        let userId = parameters["user_id"],
            token = parameters["access_token"]
        session.token = String(token!)
        session.userId = Int(userId!)!
        print("access_token" + token!)
        
        performSegue(withIdentifier: "VKLoginAccessIsOk", sender: nil)
        
        decisionHandler(.cancel)
    }
}
