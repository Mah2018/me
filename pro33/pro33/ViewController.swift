//
//  ViewController.swift
//  pro33
//
//  Created by mahmoud6 on 3/13/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    title = "what's that whistle"
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addWhistle))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
    
    
    }
    
    
    @objc func addWhistle(){
        
        let vc = RecordWhistleViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

