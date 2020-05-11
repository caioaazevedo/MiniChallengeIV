//
//  UpdateProjectViewController.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 11/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class UpdateProjectViewController: UIViewController {
    
    @IBOutlet weak var projectNameLabel: UITextField!
    
    let projectBO = ProjectBO()
    
    var project: Project?
    var projectName = String()
    var projectColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onClickColor(_ sender: UIButton) {
        var colors: [UIColor] = [
            UIColor(red: 0.72, green: 0.00, blue: 0.00, alpha: 1.00),
            UIColor(red: 0.86, green: 0.24, blue: 0.00, alpha: 1.00),
            UIColor(red: 0.99, green: 0.80, blue: 0.00, alpha: 1.00),
            UIColor(red: 0.07, green: 0.45, blue: 0.87, alpha: 1.00),
            UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 1.00)
        ]
        colors = colors.shuffled()
        projectColor = colors[0]
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        saveProject()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func saveProject() {
        showOkAlert(title: "Save", message: "Project Updated!")
    }
    
    func showOkAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
