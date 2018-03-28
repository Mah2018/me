//
//  viewController.swift
//  hackingws
//
//  Created by mahmoud6 on 2/22/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//
import CoreGraphics
import UIKit

class viewController: UITableViewController {

    
    var projects = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        projects.append(["project 1: stormViewer","Constants and variables, UITableView, UIImageView, FileManager, storyboards"])
         projects.append(["project 2: Guess the flag","Asset catalogs, UIButton, CALayer, UIColor, UIAlertController"])
        projects.append(["project 3: social media","UIBarButtonItem, UIActivityViewController, URL"])
         projects.append(["project 4: easy brower","loadView(), WKWebView, URLRequest, UIToolbar, UIProgressView, key-value observing"])
        projects.append(["project 5:word scramble","loadView(), WKWebView, URLRequest, UIToolbar, UIProgressView, key-value observing"])
        projects.append(["project 6:auto layout","NSLayoutConstraint, Visual Format Language, layout anchors"])
        projects.append(["project 7: whitehouse petitions","JSON, Data, UITabBarController"])
        projects.append(["project 8:7 swifty words","addTarget(), enumerated(), count(), index(of:), joined(), property observers, range operators"])
        projects.append(["project 9: grand dispatch queue","DispatchQueue, perform(inBackground:)"])
        projects.append(["project 10 :names to faces","UICollectionView, UIImagePickerController, UUID, classes"])
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projects.count
    }
    
     override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let project = projects[indexPath.row]
        cell.textLabel?.text = "\(project[0]) :\(project[1])"

        return cell
    }






    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
