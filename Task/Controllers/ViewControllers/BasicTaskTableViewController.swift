//
//  BasicTaskTableViewController.swift
//  Task
//
//  Created by Chris Grayston on 1/31/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit
import CoreData

class BasicTaskTableViewController: UITableViewController, ButtonTableViewCellDelegate, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        TaskController.shared.fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.shared.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TaskController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TaskController.shared.fetchedResultsController.sections?[section].indexTitle == "0" ? "Incomplete" : "Complete"
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell else { print("Couldn't cast cell correctly. "); return UITableViewCell()}
        
        let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        
        cell.delegate = self
        
        
        cell.update(withTask: task)
        cell.primaryLabel.text = task.name
        cell.updateButton(task.isComplete)
        viewDidLoad()
        // Configure the cell...
        
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
            
            TaskController.shared.remove(task: task)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskDetailSegue" {
            guard let destinationVC = segue.destination as? TaskDetailTableViewController else { return }
            guard let indexForTask = tableView.indexPathForSelectedRow else { return }
            destinationVC.task = TaskController.shared.fetchedResultsController.object(at: indexForTask)
            destinationVC.dueDateValue = TaskController.shared.fetchedResultsController.object(at: indexForTask).due
        }
    }
    
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        
        //let task = TaskController.shared.fetchedResultsController.object(at: sender.index)
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        
        
        TaskController.shared.toggleIsComplete(task: task)
        
    }
    
    
    // MARK: - NSFetchedResultsDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
            tableView.reloadData()
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Tableview creatign or deleting the section
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexset = IndexSet(integer: sectionIndex)//IndexSet(index: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexset, with: .automatic)
        case .delete:
            tableView.deleteSections(indexset, with: .automatic)
        default:
            return
        }
    }
    
    
}

