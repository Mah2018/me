//
//  Commit+CoreDataProperties.swift
//  core data test
//
//  Created by mahmoud6 on 3/1/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import Foundation
import CoreData


extension Commit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Commit> {
        return NSFetchRequest<Commit>(entityName: "Commit")
    }

    @NSManaged public var date: Date
    @NSManaged public var message: String
    @NSManaged public var sha: String
    @NSManaged public var url: String
    @NSManaged public var author: Commit

}
