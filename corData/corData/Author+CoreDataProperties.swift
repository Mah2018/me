//
//  Author+CoreDataProperties.swift
//  corData
//
//  Created by mahmoud6 on 3/27/18.
//  Copyright © 2018 mahmoud6. All rights reserved.
//

import Foundation
import CoreData


extension Author {

    @nonobjc public class func createfetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author")
    }

    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var commits: NSSet

}

// MARK: Generated accessors for commits
extension Author {

    @objc(addCommitsObject:)
    @NSManaged public func addToCommits(_ value: Commit)

    @objc(removeCommitsObject:)
    @NSManaged public func removeFromCommits(_ value: Commit)

    @objc(addCommits:)
    @NSManaged public func addToCommits(_ values: NSSet)

    @objc(removeCommits:)
    @NSManaged public func removeFromCommits(_ values: NSSet)

}
