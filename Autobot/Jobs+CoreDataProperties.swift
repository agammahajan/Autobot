//
//  Jobs+CoreDataProperties.swift
//  Autobot
//
//  Created by Agam Mahajan on 27/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Jobs {

    @NSManaged var created_at: String?
    @NSManaged var email: String?
    @NSManaged var failed: String?
    @NSManaged var id: String?
    @NSManaged var passed: String?
    @NSManaged var picture: String?
    @NSManaged var project_name: String?
    @NSManaged var run_failed: String?
    @NSManaged var test_label: String?
    @NSManaged var test_suite: String?
    @NSManaged var time_taken: String?
    @NSManaged var uuid: String?

}
