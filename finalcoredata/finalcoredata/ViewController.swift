//
//  ViewController.swift
//  finalcoredata
//
//  Created by mahmoud6 on 3/1/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var container : NSPersistentContainer!
    var commitPredicate : NSPredicate!
    var commits = [Commit]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { (storeDescription, error) in
          
            if let error = error{
                print("\(error)")
            }
            
            
        }
        
        performSelector(inBackground: #selector(fetchCommits), with: nil)

        
        
        
    }
    
    @objc func fetchCommits() {
        let newestCommitDate = getNewestCommitDate()
        
        if let data = try? String(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits")!) {
            let jsonCommits = JSON(parseJSON: data)
            let jsonCommitArray = jsonCommits.arrayValue
            
            print("Received \(jsonCommitArray.count) new commits.")
            
            DispatchQueue.main.async { [unowned self] in
                for jsonCommit in jsonCommitArray {
                    // the following three lines are new
                    let commit = Commit(context: self.container.viewContext)
                    self.configure(commit: commit, usingJSON: jsonCommit)
                }
                
                self.saveContext()
                self.loadSavedData()
            }
        }
    }
    

       
       
    
 
    

    func saveContext(){
    
        if container.viewContext.hasChanges{
            do {
              try container.viewContext.save()

            }
            
            catch {
            
                print("error \(error)")
            }
        }
    
    
    
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
        let commit = commits[indexPath.row]
        cell.textLabel!.text = commit.message
        cell.detailTextLabel!.text = commit.date.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                }
    
    }
    
    func loadSavedData(){
        
        
        
    }

    
}

