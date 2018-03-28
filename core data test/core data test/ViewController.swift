//
//  ViewController.swift
//  core data test
//
//  Created by mahmoud6 on 2/26/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UITableViewController {
    var commitPerdicate : NSPredicate?
    var container : NSPersistentContainer!
    var commits = [Commit]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "change filter", style: .plain, target: self, action: #selector(changeFilter))
     container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores{ storeDescription , error in
            
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                
                print("unresolved \(error)")
            }
        }
        
        performSelector(inBackground: #selector(fetchCommits), with: nil)
        
        loadSavedData()
            
        }
    @objc func changeFilter(){
        
        let ac = UIAlertController(title: "choose filter", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "show only fixed", style: .default){[unowned self] _ in
            
           self.commitPerdicate = NSPredicate(format: "message CONTAIN[c] fixed ")
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "message not merged ", style: .default){ [unowned self ] _ in
            self.commitPerdicate = NSPredicate(format: "NOT message BEGINWITH 'pull merge'")
            self.loadSavedData()
            
        })
        ac.addAction(UIAlertAction(title: "show recent commit", style: .default){ [unowned self] _ in
        
            let date = Date().addingTimeInterval(-43230)
            self.commitPerdicate = NSPredicate(format: "date > %@",date as NSDate )
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "show all commits", style: .default){[unowned self] _ in
            
           self.commitPerdicate = nil
            self.loadSavedData()
        })
    
        
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        
        
        
    }
    
    @objc  func fetchCommits(){
        
        if let url = URL(string : "https://api.github.com/repos/apple/swift/commits?per_page=100"){
            
            if let data = try? String(contentsOf : url) {
                
                let jsonData = JSON(parseJSON: data)
                
                let arrayValue = jsonData.arrayValue
                
                print("recieved \(arrayValue.count) new commits ")
                
                DispatchQueue.main.async {[unowned self] in
                    for value in arrayValue {
                        
                        let commit = Commit(context: self.container.viewContext)
                    
                        
                       self.configure(commit , usingJson : value)
                    }
                    self.save()
                    self.loadSavedData()
                }
            }
            
            
            
        }
        
    }
    
    
    func configure(_ context : Commit , usingJson json : JSON){
        
     context.message = json["commit"]["message"].stringValue
        context.sha = json["sha"].stringValue
        context.url = json["html_url"].stringValue
        
        let formator = ISO8601DateFormatter()
        
        context.date = formator.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()

    }
    func save() {
        
        if container.viewContext.hasChanges {
            
            
            do{
            
          try  container.viewContext.save()
                
            }catch {
                
            print ("error saving")
            }
        
        }
        
    }

  override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit" , for : indexPath)
        
        let commit = commits[indexPath.row]
        cell.textLabel?.text = commit.message
        cell.detailTextLabel?.text = commit.date.description
        
        return cell
        
    }
    
    
    func loadSavedData(){
        
        let request = Commit.createfetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.predicate = commitPerdicate
        
        request.sortDescriptors = [sort]
        do{
        commits = try container.viewContext.fetch(request)
        }catch{
            
            print("loading error \(error)")
            
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        
        
        
        
        
    }
    
    
}

