//
//  NewProjectViewController.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 29/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class NewProjectViewController: UIViewController{
    
    @IBOutlet weak var projectNameLabel: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    let projectBO = ProjectBO()
    
    var project: Project?
    var projectName = String()
    var projectColor = UIColor()
    
    weak var delegate: ReloadProjectListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectNameLabel.delegate = self
        
        if let project = project {
            projectNameLabel.text = project.name
            projectColor = project.color
            titleLabel.text = "Edit Project"
        } else {
            titleLabel.text = "Add Project"
        }
        
        projectNameLabel.text = "work"
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
        //        if let color = sender.backgroundColor {
        //            projectColor = color
        //        }
    }
    
    
    @IBAction func onClickSave(_ sender: Any) {
        saveProject()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func saveProject() {
        guard project == nil else {
            project?.name = projectNameLabel.text ?? ""
            project?.color = projectColor
            
            projectBO.update(project: project!, completion: { result in
                switch result {
                case .success():
                    dismiss(animated: true)
                    delegate?.reloadList()
                case .failure(let error):
                    self.showOkAlert(title: "Error", message: error.localizedDescription )
                }
            })
            
            return
        }
        
        
        projectBO.create(name: projectNameLabel.text ?? "MurilloTiozao", color: projectColor, completion: { result in
            
            switch result {
                
            case .success(_):
                dismiss(animated: true)
                delegate?.reloadList()
            case .failure(let error):
                self.showOkAlert(title: "Error", message: error.localizedDescription)
            }
            
        })
    }
    
    func showOkAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension NewProjectViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
