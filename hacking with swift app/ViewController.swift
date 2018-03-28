//
//  ViewController.swift
//  hacking with swift app
//
//  Created by mahmoud6 on 2/22/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices
import SafariServices

class ViewController: UITableViewController {

     var projects = [[String]]()
    var favorites = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()

        projects.append(["Project 1: Storm Viewer", "Constants and variables, UITableView, UIImageView, FileManager, storyboards"])
        projects.append(["Project 2: Guess the Flag", "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"])
        projects.append(["Project 3: Social Media", "UIBarButtonItem, UIActivityViewController, the Social framework, URL"])
        projects.append(["Project 4: Easy Browser", "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"])
        projects.append(["Project 5: Word Scramble", "Closures, method return values, booleans, NSRange"])
        projects.append(["Project 6: Auto Layout", "Get to grips with Auto Layout using practical examples and code"])
        projects.append(["Project 7: Whitehouse Petitions", "JSON, Data, UITabBarController"])
        projects.append(["Project 8: 7 Swifty Words", "addTarget(), enumerated(), count, index(of:), property observers, range operators."])
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        
        let userDefaults = UserDefaults.standard
        if let savedfavorites = userDefaults.object(forKey: "favorites") as? [Int] {
        favorites = savedfavorites
            
        }
        
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let project = projects[indexPath.row]
        cell.textLabel?.attributedText = makeAttributedString(title : project[0] , subtitle : project[1])
        
        if favorites.contains(indexPath.row){
            cell.editingAccessoryType = .checkmark
        }else {
            cell.editingAccessoryType = .none
        }
        

        return cell
    }
 
  override  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableViewAutomaticDimension
    }
    
    
    func makeAttributedString(title : String , subtitle : String) -> NSAttributedString {
        
        let titleAtributes = [NSFontAttributeName : UIFont.preferredFont(forTextStyle: .headline) , NSForegroundColorAttributeName : UIColor.purple]
        let subtitleAttributes = [NSFontAttributeName : UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string : "\(title) \n" , attributes : titleAtributes)
        let subtitleString = NSAttributedString(string : subtitle , attributes : subtitleAttributes)
        titleString.append(subtitleString)
        return titleString
    }
    
    func begainSafari(_ which : Int){
        
        if let url = URL(string : "https:// www.hackingwithswift.com/read/\(which + 1)") {
        
        let safariView = SFSafariViewController(url : url , entersReaderIfAvailable : true)
        
        present(safariView, animated: true)
        }
    }
    
    
    
    
 override   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        begainSafari(indexPath.row)
    }
    
    // Override to support conditional editing of the table view.
    /*override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
    }*/
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if favorites.contains(indexPath.row){
            return .delete
        }else {
            return .insert
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let index = favorites.index(of: indexPath.row){
                favorites.remove(at: index)
            }
            
            Deindex(item : indexPath.row)
        }else if editingStyle == .insert  {
            favorites.append(indexPath.row)
            index(item : indexPath.row)
            
        }
        
        let userDefualts = UserDefaults.standard
        userDefualts.set(favorites, forKey : "favorites")
        
    }
    
    func index(item : Int){
        
        let project = projects[item]
        
        let attributeset = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        
        attributeset.title = project[0]
        attributeset.contentDescription = project[1]
        
        let item = CSSearchableItem(uniqueIdentifier: "\(item)", domainIdentifier: "com.hackingwithswift", attributeSet: attributeset)
        item.expirationDate = Date.distantFuture
        
        CSSearchableIndex.default().indexSearchableItems([item]){ error in
            
            if let error = error {
                
                print("failed indexing error \(error.localizedDescription)")
            }else {
                
                print("indexing successful")
            }
            
            
            
        }
        
        
    }
    func Deindex(item : Int){
        
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"]){ error in
            if let error = error {
                
                print("fasiled to deindex \(error.localizedDescription)")
                
            }else {
                print("successfully deleted")
            }
            
            
        }
        
    }
    
    
    
    
    
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
