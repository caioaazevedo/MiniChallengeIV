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

enum TypeBtnTask {
    case add, select
}

class TaskBtn: UIButton {
    var btnType: TypeBtnTask!
}

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var btnCheck: TaskBtn!
    var delegate: TaskBtnDelegate?
    
    @IBAction func checkButtonAction(_ sender: TaskBtn) {
        
//        switch sender.btnType {
//
//        case .select:
            if sender.isSelected {
                sender.isSelected = false
                delegate?.changeBtnState(isSelected: false, index: sender.tag)
            }else {
                sender.isSelected = true
                delegate?.changeBtnState(isSelected: true, index: sender.tag)
            }
//        default:
//            break;
//        }
    }
}
