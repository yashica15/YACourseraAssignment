//
//  Tag+CoreDataProperties.swift
//  PhotoFeed
//
//  Created by Mike Spears on 2016-01-10.
//  Copyright © 2016 YourOganisation. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tag {

    @NSManaged var title: String?
    @NSManaged var images: NSSet?

}
