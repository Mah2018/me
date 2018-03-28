//
//  ViewController.swift
//  secrt
//
//  Created by mahmoud6 on 3/28/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var secret: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
      let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(adjustKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notification.addObserver(self, selector: #selector(adjustKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        notification.addObserver(self, selector: #selector(saveMessage), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        let context = LAContext()
        
        var error : NSError?
     if  context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
        let reason = "identify yourself"
     
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){[unowned self] (success,error) in
            
            DispatchQueue.main.async {
                
                if success {
                    
                    self.unlockMessage()
                }else {
                
                let vc = UIAlertController(title: "refused", message: nil, preferredStyle: .alert)
                    vc.addAction(UIAlertAction(title: "ok", style: .default, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
                
                }
            }
            
            
            
        }
            
            
            
            
        }
        
        
        
    }

    
    @IBAction func authinticateTapped(_ sender: Any) {
        
        unlockMessage()
        
    }
    
    func unlockMessage(){
    
    secret.isHidden = false
        if let text = KeychainWrapper.string(forKey :"hiddenMessage"){
            secret.text = text
        }
    
    
    }
    
  @objc  func saveMessage(){
        if !secret.isHidden{
        KeychainWrapper.set(secret.text,forKey:"hiddenMessage")
        }
        secret.isHidden = true
        secret.resignFirstResponder()
        
    }
    @objc func adjustKeyboard(notification : Notification){
        
       let userInfo = notification.userInfo!
        
        let keyboardonScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = view.convert(keyboardonScreenEndFrame, from: view.window)
        
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else if notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        secret.scrollRangeToVisible(secret.selectedRange)
        
        }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

