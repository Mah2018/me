//
//  DetailViewController.swift
//  core data fun
//
//  Created by mahmoud6 on 3/3/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    var detailItem : Commit?
    @IBOutlet weak var DetailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let detail = detailItem {
            
            
            DetailLabel.text = detail.message
        }
        
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
