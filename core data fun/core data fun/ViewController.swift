//
//  ViewController.swift
//  core data fun
//
//  Created by mahmoud6 on 3/3/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController ,NSFetchedResultsControllerDelegate {
    
    var fetchedResultsControllers : NSFetchedResultsController<Commit>!
    var container : NSPersistentContainer!
  //  var commits = [Commit]()
    var commitPredicate : NSPredicate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
     container = NSPersistentContainer(name: "core Data fun")
        
        container.loadPersistentStores { (storeDescription, error) in
           self .container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            if let error = error {
                
                
                print("error \(error)")
            }
        }
        
     
        performSelector(inBackground: #selector(fetchCommits), with: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "cahnge filter", style: .plain, target: self, action: #selector(changeFilter))
        loadSavedData()
        
        
    }
    @objc func fetchCommits(){
        
        let newestCommits = getNewestCommits()
        
        if let url = URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100&since=\(newestCommits)!") {
            
            if let reciviedJSON = try? String(contentsOf: url) {
                
                let jsonData = JSON(parseJSON: reciviedJSON)
                let arrayData = jsonData.arrayValue
                
               
                   
                    DispatchQueue.main.async { [unowned self] in
                        
                         for item in arrayData {
                        let commit = Commit(context: self.container.viewContext)
                        self.configure(commit : commit , usingJSON : item)
                    }
                    
                    self.saveContext()
                    self.loadSavedData()
                    

                    
                    }
                
            }
            
            
        }
    }
    func getNewestCommits()-> String {
        let formattor = ISO8601DateFormatter()
        

        let newest = Commit.createfetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        newest.sortDescriptors = [sort]
        newest.fetchLimit = 1
        if let commits = try? container.viewContext.fetch(newest){
                       if commits.count>0 {
                return formattor.string(from: commits[0].date.addingTimeInterval(1))
            }
            
            
        }
    
        return formattor.string(from: Date(timeIntervalSince1970: 0))
    }
    
    
        func configure(commit : Commit , usingJSON data : JSON){
            
            commit.sha = data["sha"].stringValue
            commit.message = data["commit"]["message"].stringValue
            commit.url = data["html_url"].stringValue
            let formattor = ISO8601DateFormatter()
            commit.date = formattor.date(from: data["commit"]["committer"]["date"].stringValue) ?? Date()
            
            
            var commitAuthor : Author!
            
            let AuthorRequest = Author.createfetchRequest()
            
            AuthorRequest.predicate = NSPredicate(format: "name ==%@" , data["commit"]["commiter"]["name"].stringValue)
            
            if let authors = try? container.viewContext.fetch(AuthorRequest) {
                
                if authors.count > 0 {
                    
                    commitAuthor = authors[0]
                }
                
                if commitAuthor == nil {
                    
                    let author = Author(context: container.viewContext)
                    author.name = data["commit"]["commiter"]["name"].stringValue
                    author.email = data["commit"]["commiter"]["email"].stringValue
                    
                    commitAuthor = author
                }
                

            }
            
            commit.author = commitAuthor
            
        }
        
        
    
    
    @objc func changeFilter() {
        let ac = UIAlertController(title: "Filter commits…", message: nil, preferredStyle: .actionSheet)
        
        // 1
        ac.addAction(UIAlertAction(title: "Show only fixes", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "message CONTAINS[c] 'fix'")
            self.loadSavedData()
        })
        
        // 2
        ac.addAction(UIAlertAction(title: "Ignore Pull Requests", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull request'")
            self.loadSavedData()
        })
        
        // 3
        ac.addAction(UIAlertAction(title: "Show only recent", style: .default) { [unowned self] _ in
            let twelveHoursAgo = Date().addingTimeInterval(-43200)
            self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo as NSDate)
            self.loadSavedData()
        })
        
        // 4
        ac.addAction(UIAlertAction(title: "Show only Durian commits", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "author.name == 'Joe Groff'")
            self.loadSavedData()
        })
        
        // 5
        ac.addAction(UIAlertAction(title: "Show all commits", style: .default) { [unowned self] _ in
            self.commitPredicate = nil
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    
    
    func loadSavedData(){
        
      let request = Commit.createfetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
        
        fetchedResultsControllers = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsControllers.fetchRequest.predicate = commitPredicate
        
        fetchedResultsControllers.delegate = self
        
        
       do
       {
       try  fetchedResultsControllers.performFetch()
       }
       catch{
             print("\(error)")
        }
    }
    

    func saveContext(){
        
        if container.viewContext.hasChanges{
            do {
            try container.viewContext.save()
            }
            catch {
            
            print("error saving \(error)")
            }
        }
    }
    
  override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit" , for : indexPath)
        
        let commit = fetchedResultsControllers.object(at: indexPath)
        cell.textLabel?.text = commit.message
    cell.detailTextLabel?.text =  " By \(commit.author.name) , \(commit.date.description)"
    return cell
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        let sectionInfo = fetchedResultsControllers.sections?[section]
        
        return (sectionInfo?.numberOfObjects)!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsControllers.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        
        vc.detailItem = fetchedResultsControllers.object(at: indexPath)

        navigationController?.pushViewController(vc, animated: true)
     }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let commit = fetchedResultsControllers.object(at: indexPath)
            container.viewContext.delete(commit)
            
            saveContext()
            
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        
        case .delete:
            tableView.deleteRows(at: [(indexPath)!], with: .automatic)
        default :
            break
        
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

