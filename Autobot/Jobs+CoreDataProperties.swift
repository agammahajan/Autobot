//
//  Jobs+CoreDataProperties.swift
//  
//
//  Created by Agam Mahajan on 23/08/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Jobs {

    @NSManaged var email: String?
    @NSManaged var failed: String?
    @NSManaged var passed: String?
    @NSManaged var picture: String?
    @NSManaged var id: String?
    @NSManaged var project_name: String?
    @NSManaged var run_failed: String?

}
