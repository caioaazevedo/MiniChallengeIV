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
    
    var currentButtonIndex = 0
    
    let projectBO = ProjectBO()
    
    var project: Project?
    var projectName = String()
    var projectColor = UIColor(red: 0.77, green: 0.87, blue: 0.96, alpha: 1.00)
    
    weak var delegate: ReloadProjectListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.dismissKeyboard()

        
        projectNameLabel.delegate = self
        
        // uncheck all colors
        for check in checks {
            check.isHidden = true
        }
        
        // if projects is not null
        if let project = project {
            projectNameLabel.text = project.name
            projectColor = project.color
            titleLabel.text = NSLocalizedString("Edit project", comment: "")
            
            // show current project color
            if let button = buttons.filter({$0.backgroundColor?.description == project.color.description}).first,
                let index = buttons.firstIndex(of: button) {
                checks[index].isHidden = false
                currentButtonIndex = index
            }
            
        }
        else {
            titleLabel.text = NSLocalizedString("Add project", comment: "")
            projectColor = buttons[0].backgroundColor!
            checks[0].isHidden = false
        }
        
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        view.endEditing(true)
    }
    
    @IBAction func onClickColor(_ sender: UIButton) {
        if let color = sender.backgroundColor {
            projectColor = color
        }
        
        if let index = buttons.firstIndex(of: sender) {
            checks[index].isHidden = false
            if currentButtonIndex != index {
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
}

extension NewProjectViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
