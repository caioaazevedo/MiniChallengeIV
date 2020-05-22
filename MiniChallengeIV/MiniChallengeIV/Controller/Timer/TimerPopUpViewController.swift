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
        self.adaptAutoLayout()
        
        updateNavigationController()
    }
    
    private func updateNavigationController() {
        let storyboard = UIStoryboard(name: "Timer", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "vc") as? TimerViewController else { return }
        
        vc.enablePopViewController(true)
    }
    
    //Set up the texts for when timer ends
    func setupDictionary(){
        //focus
        titleDict[.focus] = NSLocalizedString("Focus title", comment: "")
        textDict[.focus] = NSLocalizedString("Focus text", comment: "")
        imageDict[.focus] = UIImage(named: "trophy")
        buttonDict[.focus] = NSLocalizedString("Break", comment: "")
        //pause
        titleDict[.pause] = NSLocalizedString("Break title", comment: "")
        textDict[.pause] = NSLocalizedString("Break text", comment: "")
        imageDict[.pause] = UIImage(named: "break")
        buttonDict[.pause] = NSLocalizedString("Focus", comment: "")
        //give up
        titleDict[.givenUp] = NSLocalizedString("Give Up title", comment: "")
        textDict[.givenUp] = NSLocalizedString("Give Up text", comment: "")
        imageDict[.givenUp] = UIImage(named: "giveUp")
        buttonDict[.givenUp] = NSLocalizedString("Retry", comment: "")
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
        guard let navigation = self.presentingViewController as? UINavigationController else{return}
        guard let pvc = navigation.topViewController as? TimerViewController else {return}
        if popUpState == .givenUp{
            pvc.timeTracker.state = .focus
        }else{
            pvc.timeTracker.state = pvc.timeTracker.changeCicle
        }
        let time = pvc.timeTracker.secondsToString(with: pvc.timeTracker.convertedTimeValue)
        pvc.timerLabel.text = time
        pvc.startTimer(pvc.btnStart)
        dismiss(animated: true)
    }
    //Cancel timer and go back to menu
    @IBAction func Cancel(_ sender: Any) {
//        guard let navigation = self.presentingViewController as? UINavigationController else{return}
//        guard let pvc = navigation.topViewController as? TimerViewController else {return}
//        self.dismiss(animated: true) {
//            pvc.dismiss(animated: true)
//        }
        dismiss(animated: true)
    }
}
