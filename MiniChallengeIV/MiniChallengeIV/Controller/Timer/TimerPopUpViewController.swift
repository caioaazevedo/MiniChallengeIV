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
    
    func getTitle() -> String{
        switch self {
        case .focus:
            return "Yay!"
        case .pause:
            return ""
        case .givenUp:
            return "Ooops!"
        }
    }
    
    func getText() -> String{
        switch self {
        case .focus:
            return "Congratulations!\nYou did it!"
        case .pause:
            return ""
        case .givenUp:
            return "All of the progress was lost!\nLet's try total focus again?"
        }
    }
    
    func getImage() -> UIImage?{
        switch self {
        case .focus:
            return UIImage(named: "trophy")
        case .pause:
            return UIImage(named: "trophy")
        case .givenUp:
            return UIImage(named: "giveUp")
        }
    }
}

class TimerPopUpViewController: UIViewController {

    //Atributes
    var popUpState = PopUpMessages.focus
    //ImageView
    @IBOutlet weak var popUpImage: UIImageView!
    //Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupPopUp()
    }
    
    func setupPopUp(){
        popUpImage.image = popUpState.getImage()
        titleLabel.text = popUpState.getTitle()
        textLabel.text = popUpState.getText()
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
