//
//  ViewController.swift
//  sec
//
//  Created by mahmoud6 on 2/10/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import LocalAuthentication
class ViewController: UIViewController {

    @IBOutlet weak var secrt: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)

      
    }

    @objc func saveSecretMessage(){
    
    
    let text = secrt.text
        
        if !secrt.isHidden {
        
        KeychainWrapper.standard.set(text!, forKey: "secrtMessage")
            secrt.isHidden = true
            secrt.resignFirstResponder()
            
            title = "nothing to show here"
        }

    }
    
    
    @IBAction func authenticateTapped(_ sender: UIButton) {
        
        let context = LAContext()
        var error : NSError?
        
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
        
        
        let reason = "Identify yourself"
            
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
            
            [unowned self] (success , error) in
                
            
                DispatchQueue.main.async {
                    if success {
                    
                    self.unlockSecretMessage()
                    }else {
                    
                    
                        let ac = UIAlertController(title :"error" , message : "can't figure out ID" , preferredStyle : .alert)
                        ac.addAction(UIAlertAction(title : "ok" , style : .cancel))
                        self.present(ac, animated: true)
                    
                    
                    }
                    
                    
                }
            
            
            
            
            
            }
        }else
        {let ac = UIAlertController(title : "error" , message : "your device doesn't support touch /face ID" , preferredStyle : .alert)
        
            ac.addAction(UIAlertAction(title :"ok " , style : .cancel))
            self.present(ac, animated: true)
    
        
        
        
        }
    }
    
    func unlockSecretMessage(){
    
        secrt.isHidden = false
        if let text = KeychainWrapper.standard.string(forKey: "secretMessage") {
        
            secrt.text = text
            
        
        }

    
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            secrt.contentInset = UIEdgeInsets.zero
        } else {
            secrt.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        secrt.scrollIndicatorInsets = secrt.contentInset
        
        let selectedRange = secrt.selectedRange
        secrt.scrollRangeToVisible(selectedRange)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

