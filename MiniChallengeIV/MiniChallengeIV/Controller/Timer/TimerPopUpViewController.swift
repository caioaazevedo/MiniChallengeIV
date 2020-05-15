//
//  TimerPopUpViewController.swift
//  MiniChallengeIV
//
//  Created by Fábio Maciel de Sousa on 14/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit
//Types of messages it should display
enum PopUpMessages{
    case focus
    case pause
    case givenUp
}

class TimerPopUpViewController: UIViewController {

    //MARK: Atributes
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
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupDictionary()
        setupPopUp()
        adaptAutoLayout()
    }
    //Adapt auto layout according to device
    func adaptAutoLayout(){
        //Get all screen sizes
        let screenElements = self.view.subviewsRecursive()
        let constraints = screenElements.map{$0.constraints}.joined()
        for constraint in constraints {
            if constraint.identifier == "height" {
                constraint.constant = constraint.constant.scaledHeight
            } else if constraint.identifier == "width" {
                constraint.constant = constraint.constant.scaledWidth
            }
        }
        
        //Adapt label sizes
        textLabel.font = textLabel.font.withSize(textLabel.font.pointSize.scaledHeight)
        titleLabel.font = titleLabel.font.withSize(titleLabel.font.pointSize.scaledHeight)
        button.titleLabel?.font = button.titleLabel?.font.withSize((button.titleLabel?.font.pointSize.scaledHeight)!)
        cancelButton.titleLabel?.font = cancelButton.titleLabel?.font.withSize((cancelButton.titleLabel?.font.pointSize.scaledHeight)!)
    }
    //Set up the texts for when timer ends
    func setupDictionary(){
        //focus
        titleDict[.focus] = "Yay!"
        textDict[.focus] = "Congratulations!\nYou did it!"
        imageDict[.focus] = UIImage(named: "trophy")
        buttonDict[.focus] = "Break"
        //pause
        titleDict[.pause] = "OK!"
        textDict[.pause] = "Break is over!\nNow It's time to focus again."
        imageDict[.pause] = UIImage(named: "break")
        buttonDict[.pause] = "Focus"
        //give up
        titleDict[.givenUp] = "Ooops!"
        textDict[.givenUp] = "All of the progress was lost!\nLet's try total focus again?"
        imageDict[.givenUp] = UIImage(named: "giveUp")
        buttonDict[.givenUp] = "Retry"
    }
    //Set all labels and buttons
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
    //Go to next step Focus/Break
    @IBAction func goToNextStep(_ sender: Any) {
        guard let pvc = self.presentingViewController as? TimerViewController else{return}
        if popUpState == .givenUp{
            pvc.timeTracker.state = .focus
        }else{
            pvc.timeTracker.state = pvc.timeTracker.changeCicle
        }
        dismiss(animated: true)
    }
    //Cancel timer and go back to menu
    @IBAction func Cancel(_ sender: Any) {
        guard let pvc = self.presentingViewController as? TimerViewController else{return}
        self.dismiss(animated: true) {
            pvc.dismiss(animated: true)
        }
    }
}
