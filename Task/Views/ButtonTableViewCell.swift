//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by Chris Grayston on 1/30/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit
@IBDesignable

class ButtonTableViewCell: UITableViewCell {

    // MARK: - Properties
    weak var delegate: ButtonTableViewCellDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateButton(_ isComplete: Bool) {
        if isComplete {
            completedButton.setImage(UIImage(named: "complete"), for: .normal)
        } else {
            completedButton.setImage(UIImage(named: "incomplete"), for: .normal)
        }
        
        
    }
    
    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: Any) {
        
        
        // check if a delegate is assigned, and if so, call the delegate protocol function
        if let delegate = delegate {
            delegate.buttonCellButtonTapped(self)
        }
    }
    
    
    
}

extension ButtonTableViewCell {
    func update(withTask task: Task) {
        primaryLabel.text = task.name
        updateButton(task.isComplete)
    }
    
}

protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}
