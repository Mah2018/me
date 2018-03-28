//
//  ViewController.swift
//  stackViewkl
//
//  Created by mahmoud6 on 3/27/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//
import CoreSpotlight
import MobileCoreServices
import SafariServices
import UIKit

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
        let defaults = UserDefaults.standard
        
        if let savedFavorites = defaults.object(forKey: "favo") as? [Int] {
            favorites = savedFavorites
        }
        
        
        
           }
    
    func showTot(_ which : Int){
        
        if let lesson = URL(string: "https://www.hackingwithswift.com/read/\(which + 1)"){
            
            let vc = SFSafariViewController(url: lesson, entersReaderIfAvailable: true)
            
            present(vc, animated: true)
            
        }
        
    }
    
    
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTot(indexPath.row)
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return  projects.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let project = projects[indexPath.row]
        cell.textLabel?.attributedText = makeAtrributtedString(title: project[0], subtitle: project[1])
        
        if favorites.contains(indexPath.row){
            cell.editingAccessoryType = .checkmark
        }else{
            cell.editingAccessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if favorites.contains(indexPath.row){
            return .delete
        }else {
            return .insert
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .insert {
            
            favorites.append(indexPath.row)
            index(item : indexPath.row)
        }else {
            if let index = favorites.index(of: indexPath.row) {
                favorites.remove(at: index)
                deindex(item : indexPath.row)
            }
        }
        
        let defaults = UserDefaults.standard
        defaults.set(favorites, forKey: "favo")
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    
    func index(item : Int){
        let project = projects[item]
        
        let atributtedSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        atributtedSet.title = project[0]
        atributtedSet.contentDescription = project[1]
        
        let index = CSSearchableItem(uniqueIdentifier: "\(item)", domainIdentifier: "com.hackingwithswift", attributeSet: atributtedSet)
        CSSearchableIndex.default().indexSearchableItems([index]){error in
            if let error = error {
                print("indexing failed \(error)")
            }else{
                print("succeeded")
            }
        }
        
    }
    
    func deindex(item : Int ) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"]){ error in
            
            
        }
        
    }
    func makeAtrributtedString(title : String , subtitle : String)-> NSAttributedString {
        
        let titleAtrributed = [NSFontAttributeName : UIFont.preferredFont(forTextStyle: .headline) ,NSForegroundColorAttributeName : UIColor.purple]
        let subtitleAtrributed = [NSFontAttributeName : UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title) \n", attributes: titleAtrributed)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAtrributed)
        titleString.append(subtitleString)
        return titleString
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

