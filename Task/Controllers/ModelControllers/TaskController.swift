//
//  TaskController.swift
//  Task
//
//  Created by Chris Grayston on 1/30/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    // MARK: - Properties
    // MARK: - Shared Instance
    static let shared = TaskController()
    
    let fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        let isCompleteSort = NSSortDescriptor(key: "isComplete", ascending: true)
        
        let dueSort = NSSortDescriptor(key: "due", ascending: true)
        fetchRequest.sortDescriptors = [isCompleteSort, dueSort]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        
    }()
    
    init() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error permorming fetch on fetchResultsController \(error): \(error.localizedDescription)")
        }
    }

    
    func add(taskWithName name: String, notes: String?, due: Date?) {
        Task(name: name, notes: notes, due: due, managedObjectContext: CoreDataStack.context)
        
        saveToPersistentStore()
        //tasks = fetchTasks()
    }
    
    func update(task: Task, name: String, notes: String?, due: Date?){
        task.name = name
        task.notes = notes
        task.due = due
        
        saveToPersistentStore()
        
        //tasks = fetchTasks()
    }
    
    // TODO - Temporary
    func remove(task: Task) {
        //guard let index = tasks.index(of: task) else { return }
        //tasks.remove(at: index)
        if let moc = task.managedObjectContext {
            moc.delete(task)
        }
        
        saveToPersistentStore()
        //tasks = fetchTasks()
        
    }
    
    func toggleIsComplete(task: Task) {
        task.isComplete = !task.isComplete
        TaskController.shared.saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("There was a problem saving to persistent store: \(error) : \(error.localizedDescription)" )
        }
    }
    
}
