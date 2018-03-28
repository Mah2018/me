//
//  ViewController.swift
//  Project31
//
//  Created by TwoStraws on 23/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    weak var activeWebView: UIWebView?

    @IBOutlet weak var addressBar: UITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
    }
    
    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    @objc func addWebView() {
        let webView = UIWebView()
        webView.delegate = self
        
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.loadRequest(URLRequest(url: url))
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    
    @objc func deleteWebView() {
      
    
        if let webView = activeWebView {
            
            if let index = stackView.arrangedSubviews.index(of: webView){
            
            stackView.removeArrangedSubview(webView)
            stackView.removeFromSuperview()
            
            var currentIndex = Int(index)
            
                if currentIndex == stackView.arrangedSubviews.count {
                    currentIndex = stackView.arrangedSubviews.count-1
                
                }
                
                let newselected = stackView.arrangedSubviews[currentIndex]
        
                selectWebView(newselected as! UIWebView)
            }
            
            
        }
    
    }
    
    func selectWebView(_ webView: UIWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        
        activeWebView = webView
        webView.layer.borderWidth = 3
        
      //  updateUI(for: webView)
    }
    
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? UIWebView {
            selectWebView(selectedWebView)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let webView = activeWebView, let address = addressBar.text {
            if let url = URL(string: address) {
                webView.loadRequest(URLRequest(url: url))
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    /*override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }*/
    
    /*func updateUI(for webView: UIWebView) {
        title = webView.stringByEvaluatingJavaScript(from: "document.title")
        addressBar.text = webView.request?.url?.absoluteString ?? ""
    }*/
    
    /*func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView == activeWebView {
            updateUI(for: webView)
        }
    }*/
}

