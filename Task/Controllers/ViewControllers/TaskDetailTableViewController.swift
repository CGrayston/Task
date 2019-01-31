//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Chris Grayston on 1/30/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {

    // MARK: - Properties
    // when we pass the task from prepare(for segue:...) function to the task computed property it will update the views to reflect the properties of the selected task.
    var task: Task? {
        didSet {
            // Call this because the task data hasn't fully loaded yet
            loadViewIfNeeded()
            updateViews()
        }
    }
    var dueDateValue: Date?
    
    // MARK: - IBOutlets
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        dueDateTextField.inputView = dueDatePicker
    }

    


    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // save a new task if the task property is nil and update the existing task otherwise (even though we haven't set it yet, use dueDateValue for the date that you pass into your add and update functions.
        updateTask()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dueDateValue = dueDatePicker.date
        dueDateTextField.text = dueDateValue?.stringValue()
    }
     // TODO not resigning
    @IBAction func userTappedView(_ sender: Any) {
        self.taskTextField.resignFirstResponder()
        self.dueDateTextField.resignFirstResponder()
        self.notesTextView.resignFirstResponder()
    }
    
    func updateTask() {
        guard let name = taskTextField.text, let notes = notesTextView.text else { return }
        if let task = task  {
            TaskController.shared.update(task: task, name: name, notes: notes, due: dueDateValue)
        } else {
            if name != "" {
            TaskController.shared.add(taskWithName: name, notes: notes, due: dueDateValue)
            }
        }
    }
    
    func updateViews() {
        guard let task = task else { print("Error unwrapping task "); return }
        self.title = "\(task.name ?? "") Journal"
        taskTextField.text = task.name
        dueDateTextField.text = task.due?.stringValue() // TODO task?.due
        notesTextView.text = task.notes
        
        // TODO: check to see if the view has been loaded
        
    }
    
    // MARK: - Table view data source
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

}
