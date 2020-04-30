//
//  NewProjectViewController.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 29/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class NewProjectViewController: UIViewController {

    @IBOutlet weak var projectNameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickColor(_ sender: UIButton) {
        print(sender.backgroundColor!)
    }
    
    @IBAction func onClickDelete(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        print(projectNameLabel.text ?? "")
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
