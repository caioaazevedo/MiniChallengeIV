//
//  TaskTableViewCell.swift
//  MiniChallengeIV
//
//  Created by Carlos Fontes on 06/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation
import UIKit

protocol TaskBtnDelegate {
    func changeBtnState(isSelected: Bool, index: Int)
}

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var btnCheck: UIButton!
    var delegate: TaskBtnDelegate?
    
    @IBAction func checkButtonAction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            delegate?.changeBtnState(isSelected: false, index: sender.tag)
        }else {
            sender.isSelected = true
            delegate?.changeBtnState(isSelected: true, index: sender.tag)
        }
        
        
    }
}
