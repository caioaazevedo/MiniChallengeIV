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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var checks: [UIImageView]!
    
    var currentButtonIndex: Int?
    
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
        
        for check in checks {
            check.isHidden = true
        }
                
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @IBAction func onClickColor(_ sender: UIButton) {
        if let color = sender.backgroundColor {
            projectColor = color
        }
        
        if let index = buttons.firstIndex(of: sender) {
            checks[index].isHidden = false
            if let currentButtonIndex = currentButtonIndex {
                checks[currentButtonIndex].isHidden = true
            }
            currentButtonIndex = index
        }
        
    }
    
//    @IBAction func onClickDelete(_ sender: Any) {
//
//        projectBO.delete(uuid: project!.id, completion: { result in
//            switch result {
//
//            case .success():
//                delegate?.reloadList()
//                dismiss(animated: true)
//            case .failure(let error):
//                showOkAlert(title: "Error", message: error.localizedDescription)
//            }
//        })
//
//    }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension NewProjectViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
