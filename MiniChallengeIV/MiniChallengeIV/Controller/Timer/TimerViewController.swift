//
//  TimerViewController.swift
//  MiniChallengeIV
//
//  Created by Fábio Maciel de Sousa on 29/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit
import AudioUnit

///Place holder ViewController
class TimerViewController: UIViewController {
    
    //Atributes
    let timeTracker = TimeTrackerBO()
    var timeRecover: TimeRecoverBO?
    var id: UUID?
    var project: Project?
    let projectBO = ProjectBO()
    let taskBO = TaskBO()
    var tasks: [Task] = []
    //Properties
    ///the validation for the minimum value
    var minimumDecrement: Int{
        //TODO: switch 0 for a generic number
        if timeTracker.configTime - 5  < 5{
            shakeView(timerLabel)
            return 5
        }
        return timeTracker.configTime - 5
    }
    ///the validation for the maximum value
    var maximumDecrement: Int{
        //TODO: switch 60 for a generic number
        if timeTracker.configTime + 5  > 480{
            shakeView(timerLabel)
            return 480
        }
        return timeTracker.configTime + 5
    }
    
    //Buttons, Labels
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var timeConfigButtons: [UIButton]!
    @IBOutlet weak var stateLabel: UILabel!
    //Ring View
    @IBOutlet weak var projectColor: UIView!
    @IBOutlet weak var ringView: AnimatedRingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProject()
        loadTasks()
        
        self.btnStart.layer.cornerRadius = 10.0
        self.btnStart.backgroundColor = UIColor(red: 0.35, green: 0.49, blue: 0.49, alpha: 1.00)
        self.tableView.separatorColor = .clear
        
        // Do any additional setup after loading the view.
        timerLabel.text = timeTracker.secondsToString(with: timeTracker.convertedTimeValue)
        
        timeTracker.state = .focus
        
        self.timeRecover = TimeRecoverBO(timer: timeTracker)
        
        /// Get Scene Deleegate
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sd.timer = self.timeTracker
            sd.timeRecover = self.timeRecover
            sd.ringView = self.ringView
        }
        
        self.stateLabel.text = project?.name
        projectColor.backgroundColor = project?.color
        projectColor.layer.cornerRadius = 15.0

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        view.endEditing(true)
    }
    
    func loadProject(){
        guard let id = self.id else { return }
        projectBO.fetch(id: id, completion: { result in
            switch result {
            case .success(let project):
                self.project = project
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func loadTasks(){
        guard let id = self.id else { return }
        taskBO.retrieve(id: id, completion: { result in
            
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    
    //MARK: START TIMER
    @IBAction func startTimer(_ sender: UIButton) {
        if timeTracker.timer.isValid { // If it's running it stops instead
            stopTimer(sender)
            return
        }
        var text = NSLocalizedString("Give Up", comment: "")
        sender.setTitle(text, for: .normal)
        //Disable screen block
        UIApplication.shared.isIdleTimerDisabled = true
        //Start timer
        timeTracker.startTimer {time, hasEnded in
            if hasEnded{ // Focus timer ended
                text = NSLocalizedString("Start", comment: "")
                sender.setTitle(text, for: .normal)
                self.setConfigurationButtons()
                self.ringView.removeAnimation()
                let popUpState = self.timeTracker.state == .focus ? PopUpMessages.focus : .pause
                self.presentPopUp(state: popUpState)
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            self.timerLabel.text = time
        }
        //Animate progression ring
        ringView.animateRing(From: 0, FromAngle: 0, To: 1, Duration: CFTimeInterval(timeTracker.convertedTimeValue))
        ringView.totalTime = CGFloat(timeTracker.convertedTimeValue)
        //Enable or disable buttons
        setConfigurationButtons()
        //set notification
        let notificationType = timeTracker.state == .focus ? NotificationType.didFinishFocus : .didFinishBreak
        let delay = TimeInterval(timeTracker.convertedTimeValue)
        AppNotificationBO.shared.sendNotification(type: notificationType, delay: delay)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
    }
        
    //MARK: STOP TIMER
    func stopTimer(_ sender: UIButton) {
        let text = NSLocalizedString("Start", comment: "")
        sender.setTitle(text, for: .normal)
        
        timeTracker.stopTimer(){
            //TODO: Message for when the user gives up
            self.stateLabel.text = self.timeTracker.state.rawValue
            self.timerLabel.text = self.timeTracker.secondsToString(with: self.timeTracker.convertedTimeValue)
            self.ringView.removeAnimation()
        }
        setConfigurationButtons()
        presentPopUp(state: .givenUp)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        self.navigationController?.navigationBar.topItem?.hidesBackButton = false
        //Disable screen block
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    ///Show Pop Up
    func presentPopUp(state: PopUpMessages){
        if let tpvc = UIStoryboard.loadView(from: .TimerPopUp, identifier: .TimerPopUpID) as? TimerPopUpViewController {
            tpvc.modalTransitionStyle = .crossDissolve
            tpvc.modalPresentationStyle = .overCurrentContext
            tpvc.popUpState = state
            self.present(tpvc, animated: true)
        }
    }
    
    ///Shake view animation
    func shakeView(_ viewToShake: UIView){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))

        viewToShake.layer.add(animation, forKey: "position")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    ///Increment timer for the count down
    @IBAction func incrementTimer(_ sender: Any) {
        timeTracker.configTime = maximumDecrement
        timerLabel.text = timeTracker.secondsToString(with: timeTracker.convertedTimeValue)
    }

    ///Decrement timer for the count down
    @IBAction func decrementTimer(_ sender: Any) {
        timeTracker.configTime = minimumDecrement
        timerLabel.text = timeTracker.secondsToString(with: timeTracker.convertedTimeValue)
    }
    
    ///Method for disabling the buttons that are configuring the Timer
    func setConfigurationButtons(){
        let value = timeTracker.state != .pause && !timeTracker.timer.isValid ? true : false
        for button in timeConfigButtons{
            button.isEnabled = value
        }
    }
    
    
    @IBAction func addTask(_ sender: Any) {
        
        DispatchQueue.main.async {
            let task = Task(id: UUID(), description: "")
            self.tasks.append(task)
            let indexPath = IndexPath(row: self.tasks.count-1, section: 0)
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .none)
            self.tableView.endUpdates()
            
            self.tableView.layoutIfNeeded()
            
            
            self.tableView.scrollToRow(at: indexPath,
                                       at: UITableView.ScrollPosition.bottom,
                                       animated: true)
            if let cell = self.tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                cell.taskTextField.becomeFirstResponder()
            }
            
        }
        
    }
}

extension TimerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        
        cell.taskTextField.delegate = self
        cell.taskTextField.tag = indexPath.row
        cell.btnCheck.tag = indexPath.row
        cell.delegate = self
        

        
        cell.btnCheck.setImage(UIImage(named: "Oval Copy 2"), for: .normal)
        cell.btnCheck.isSelected = tasks[indexPath.row].state
        if !tasks[indexPath.row].state {
            cell.taskTextField.text = tasks[indexPath.row].description
        }else {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: tasks[indexPath.row].description)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.taskTextField.attributedText = attributeString
            cell.taskTextField.textColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1.00)
        }
        
        return cell
    }

}

// Tex field

extension TimerViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == tasks.count-1{
            if let projectCD = project?.projectCD, let description = textField.text {
                projectBO.addTask(description: description, projectCD: projectCD, completion: { result in
                    
                    switch result {
                        
                    case .success():
                        loadTasks()
                    case .failure(let error):
                        print(error)
                    }
                })
            }
            
        }else {
            var actuallyTask = tasks[textField.tag]
            actuallyTask.description = textField.text!
            
            taskBO.update(task: actuallyTask, completion: {result in
                switch result {
                    
                case .success():
                    loadTasks()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
}


extension TimerViewController: TaskBtnDelegate {
    func changeBtnState(isSelected: Bool, index: Int) {
        var task = self.tasks[index]
        task.state = isSelected
        
        taskBO.update(task: task, completion: { result in
            switch result {
                
            case .success():
                loadTasks()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}

