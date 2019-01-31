//
//  Task+Convenience.swift
//  Task
//
//  Created by Chris Grayston on 1/30/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import CoreData

// TODO notes and due are optional
extension Task {
    @discardableResult
    
    convenience init(name: String, notes: String? = nil, due: Date? = nil, managedObjectContext: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: managedObjectContext)
        
        self.name = name
        self.notes = notes
        self.due = due as Date?
        self.isComplete = false
    }
}
