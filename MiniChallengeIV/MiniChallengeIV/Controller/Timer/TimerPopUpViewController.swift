//
//  TimerPopUpViewController.swift
//  MiniChallengeIV
//
//  Created by Fábio Maciel de Sousa on 14/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

enum PopUpMessages{
    case focus
    case pause
    case givenUp
}

class TimerPopUpViewController: UIViewController {

    //Atributes
    var popUpState = PopUpMessages.focus
    //Dictionary
    var titleDict = [PopUpMessages:String]()
    var textDict = [PopUpMessages:String]()
    var imageDict = [PopUpMessages:UIImage?]()
    var buttonDict = [PopUpMessages:String]()
    //ImageView
    @IBOutlet weak var popUpImage: UIImageView!
    //Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupDictionary()
        setupPopUp()
        adaptAutoLayout()
    }
    
    func adaptAutoLayout(){
        let screenElements = self.view.subviewsRecursive()
        let constraints = screenElements.map{$0.constraints}.joined()
        for constraint in constraints {
            if constraint.identifier == "height" {
                constraint.constant = constraint.constant.scaledHeight
            } else if constraint.identifier == "width" {
                constraint.constant = constraint.constant.scaledWidth
            }
        }
        
        //adapt label sizes
        textLabel.font = textLabel.font.withSize(textLabel.font.pointSize.scaledHeight)
        titleLabel.font = titleLabel.font.withSize(titleLabel.font.pointSize.scaledHeight)
        button.titleLabel?.font = button.titleLabel?.font.withSize((button.titleLabel?.font.pointSize.scaledHeight)!)
        cancelButton.titleLabel?.font = cancelButton.titleLabel?.font.withSize((cancelButton.titleLabel?.font.pointSize.scaledHeight)!)
    }
    
    func setupDictionary(){
        //focus
        titleDict[.focus] = "Yay!"
        textDict[.focus] = "Congratulations!\nYou did it!"
        imageDict[.focus] = UIImage(named: "trophy")
        buttonDict[.focus] = "Break"
        //pause
        titleDict[.pause] = ""
        textDict[.pause] = ""
        imageDict[.pause] = UIImage(named: "trophy")
        buttonDict[.pause] = "Focus"
        //give up
        titleDict[.givenUp] = "Ooops!"
        textDict[.givenUp] = "All of the progress was lost!\nLet's try total focus again?"
        imageDict[.givenUp] = UIImage(named: "giveUp")
        buttonDict[.givenUp] = "Retry"
    }
    
    func setupPopUp(){
        guard let title = titleDict[popUpState] else {return}
        guard let text = textDict[popUpState] else {return}
        guard let image = imageDict[popUpState] else {return}
        guard let buttonText = buttonDict[popUpState] else {return}
        popUpImage.image = image
        titleLabel.text = title
        textLabel.text = text
        button.setTitle(buttonText, for: .normal)
    }
    
    @IBAction func goToNextStep(_ sender: Any) {
        guard let pvc = self.presentingViewController as? TimerViewController else{return}
        if popUpState == .givenUp{
            pvc.timeTracker.state = .focus
        }else{
            pvc.timeTracker.state = pvc.timeTracker.changeCicle
        }
        dismiss(animated: true)
    }

    @IBAction func Cancel(_ sender: Any) {
        guard let pvc = self.presentingViewController as? TimerViewController else{return}
        self.dismiss(animated: true) {
            pvc.dismiss(animated: true)
        }
    }
}
