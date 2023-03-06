//
//  TaskTypeCell.swift
//  To-Do Manager
//
//  Created by Дмитрий Гусев on 30.11.2022.
//

import UIKit

class TaskTypeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet var typeTitle: UILabel!
    @IBOutlet var typeDescription: UILabel!
    
}
