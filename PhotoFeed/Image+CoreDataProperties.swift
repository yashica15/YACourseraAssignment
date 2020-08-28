//
//  Image+CoreDataProperties.swift
//  PhotoFeed
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Image {

    @NSManaged var imageURL: String?
    @NSManaged var title: String?
    @NSManaged var tag: Tag?

}
