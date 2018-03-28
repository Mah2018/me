//
//  ViewController.swift
//  corData
//
//  Created by mahmoud6 on 3/27/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UITableViewController , NSFetchedResultsControllerDelegate {
    var fetchedResultsController : NSFetchedResultsController<Commit>!
    var commitpredicate : NSPredicate?
    var commits = [Commit]()
    var container : NSPersistentContainer!
    override func viewDidLoad() {
        super.viewDidLoad()

    container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { (description, error) in
            
            if let error = error {
                print("\(error)")
            }
        }
        
      performSelector(inBackground: #selector(fetchCommits), with: nil)
    commitpredicate = nil
    
    }
    @objc func fetchCommits() {
        if let data = try? String(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100")!) {
            let jsonCommits = JSON(parseJSON: data)
            let jsonCommitArray = jsonCommits.arrayValue
            
            print("Received \(jsonCommitArray.count) new commits.")
            
            DispatchQueue.main.async { [unowned self] in
                for jsonCommit in jsonCommitArray {
                    
                    
                    let commit = Commit(context: self.container.viewContext)
                    self.configure(commit: commit, usingJSON: jsonCommit)
                }
                
                self.saveContext()
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
        
        let commit = commits[indexPath.row]
        cell.textLabel!.text = commit.message
        cell.detailTextLabel!.text = commit.date.description
        
        return cell
    }
    
    
    func configure(commit: Commit, usingJSON json: JSON) {
        commit.sha = json["sha"].stringValue
        commit.message = json["commit"]["message"].stringValue
        commit.url = json["html_url"].stringValue
        
        let formatter = ISO8601DateFormatter()
        commit.date = formatter.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()
       
        var authorcommit : Author!
        
        let authorrequest = Author.createfetchRequest()
        
        authorrequest.predicate = NSPredicate(format: "name == %@" , json["commit"]["committer"]["name"].stringValue )
        
        if let authors = try? container.viewContext.fetch(authorrequest) {
          
            if authors.count > 0 {
                
                authorcommit = authors[0]
                
            }
        
        }
        if authorcommit == nil {
            
            let  author = Author(context: container.viewContext)
            author.name = json["commit"]["committer"]["name"].stringValue
            author.email = json["commit"]["committer"]["email"].stringValue
            
        
        authorcommit = author
        }
        
        
        commit.author = authorcommit
    }

    func saveContext(){
        
        if container.viewContext.hasChanges {
            do { try container.viewContext.save()
            
            }catch {
                print("\(error)")
            
            }
        }
        
    }
  
    func loadSavedData(){
        
    
        
        
        let request = Commit.createfetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.fetchRequest.predicate = commitpredicate
        fetchedResultsController.delegate = self
        
        
        
        do {
       try fetchedResultsController.performFetch()
        }catch{
            print("error")
        }
        tableView.reloadData()
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

