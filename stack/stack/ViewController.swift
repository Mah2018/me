//
//  ViewController.swift
//  stack
//
//  Created by mahmoud6 on 3/28/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate , UITextFieldDelegate, UIGestureRecognizerDelegate {

    
    
    var activeWebView : UIWebView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addressBar: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        
        navigationItem.rightBarButtonItems = [add , delete]
        setDefaultTitle()
        
        
        
        
    }

    
    @objc func addWebView(){
    let webView = UIWebView()
        webView.delegate = self
        webView.layer.borderColor = UIColor.blue.cgColor
        stackView.addArrangedSubview(webView)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    @objc func webViewTapped(_ recognizer : UITapGestureRecognizer){
        if let webview = recognizer.view as? UIWebView {
        
            selectWebView(webView:webview)
        }
        
    }
    func selectWebView(webView : UIWebView){
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        activeWebView = webView
        webView.layer.borderWidth = 5
        
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let webView = activeWebView ,let address = addressBar.text {
            
        }
        textField.resignFirstResponder()
        return true
    }
    @objc func deleteWebView(){
        
    }
    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        }else{
            stackView.axis = .horizontal
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

