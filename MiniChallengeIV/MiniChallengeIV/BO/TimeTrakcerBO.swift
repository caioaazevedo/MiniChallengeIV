//
//  TimeTrakcerBO.swift
//  MiniChallengeIV
//
//  Created by Fábio Maciel de Sousa on 29/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

enum TimeTrackerState: String{
    case focus
    case pause
}

///Class created for handling the count down
class TimeTrackerBO{
    
    //MARK:Atributes
    var timer = Timer()
    private var statisticBO = StatisticBO()
    private var projectBO = ProjectBO()
    var projectUuid = UUID()
    var configTime = 25
    var hasEnded = false
    var timeInterval : TimeInterval = 1 //seconds at a time
    
    var qtdLostFocus = 0
    var focusTime = 0
    var lostFocusTime = 0
    var restTime = 0
    ///Ends when value gets to zero
    var countDown = 0{
        willSet{
            if newValue <= 0{
                hasEnded = true
            }
        }
    }
    
    //MARK:Properties
    ///Converted minutes to seconds
    ///If the state is pause, it calculates the pause time
    var convertedTimeValue: Int{
        if state == .pause{
            return (configTime / 5) * 60
        }
        return configTime * 60
    }
    //MARK:States
    ///State according to view
    var state = TimeTrackerState.focus{
        didSet{
            self.focusTime = 0
            self.lostFocusTime = 0
            self.restTime = 0
            self.qtdLostFocus = 0
        }
    }
    var changeCicle: TimeTrackerState{
        return state == .focus ? .pause : .focus
    }
    //MARK: Methods
    /**
     Method for starting the count down from an initial value, and also handling view updates.
     
     If another countDown has already started, a new one won't start.The initial value must be greater than 0
     
     - Parameter minutes: the initial value in minutes which the countDown will start from.
     - Parameter updateView: a closure called each time the timer is updated for handling view updates.
     */
    func startTimer(updateView: @escaping (String, Bool) -> Void){
        countDown = convertedTimeValue
        hasEnded = false
        
        //Runs timer and updates each second
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
            self.countDown -= 1 //Decreases time
            var convertedTimeText = self.secondsToString(with: self.countDown)
            self.updateTrackedValues()
            
            if self.hasEnded{ //It changes state, cancels timer and updates view with default value
                self.timer.invalidate()
                self.updateStatistics()
                self.state = self.changeCicle
                let defaultTimeText = self.secondsToString(with: self.convertedTimeValue)
                convertedTimeText = defaultTimeText
            }
            
            updateView(convertedTimeText,self.hasEnded)
        })
    }
    
    /**
     Method for updating the tracked values which will be stored in the Data Base
     */
    func updateTrackedValues(){
        if state == .focus{
            self.focusTime += 1
        }else if state == .pause{
            self.restTime += 1
        }
    }
    
    /**
     Method for stopping the count down.
     
     if the count down was running it pop up a message to the user.
     */
    func stopTimer(updateView: @escaping () -> Void){
        timer.invalidate()
        updateView()
        updateStatistics()
        state = .focus
    }
    
    /**
     Method for converting seconds to the formatted string to be displayed on the view
     - Parameter seconds: the current unformatted second from the count down
     - Returns: formatted string of the current time in minutes and seconds
     */
    func secondsToString(with seconds: Int) -> String{
        if seconds < 0 {return ""} //TODO: send error
        var min = (seconds / 60)
        let hour = (min / 60) % 60
        min %= 60
        let sec = seconds % 60
        return String(format:"%02i:%02i:%02i",hour, min, sec)
    }
    
    /**
     Method for converting strings to seconds
     - Parameter text: the text from the label in the view
     - Returns: the amount of seconds for the count down
     */
    func stringToSeconds(from text: String) -> Int{
        if text.contains("-") { return 0}
        if !text.contains(":") { return 0}
        let numbers = text.split(separator: ":")
        if numbers.count != 3 { return 0}
        guard let hour = Int(numbers[0]) else {return 0}
        guard var min = Int(numbers[1]) else {return 0}
        min += hour * 60
        let sec = min * 60
        return sec
    }
    
    ///Method for updating statistics based on timer atributes
    func updateStatistics() {
        //create statistics based on Timer
        var statistic = Statistic(id: UUID(), focusTime: focusTime, lostFocusTime: lostFocusTime, restTime: restTime, qtdLostFocus: qtdLostFocus, year: 0, month: 0)
        //update Project
        if updateProject(statistic: statistic){
            print("Project Updated")
        }
        //Retrieve statistic from Data Base
        statisticBO.retrieveStatistic { (result) in
            
            switch result {
            case .success(let statistics):
                guard let dbStatistics = statistics else {return}
                //get current date
                let components = getDate()
                guard let year = components.year,
                    let month = components.month else {return}
                //Filter statistic from current month
                let dbStatisticFilter = (dbStatistics.filter{$0.month == month && $0.year == year})
                //Check if current month has statistic and add Timer statistics to it
                guard let dbStatistic = dbStatisticFilter.first else {return}
                statistic += dbStatistic
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        statisticBO.updateStatistic(statistics: statistic) { (result) in
            switch result {
            case .success(_): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /**
     Method for updating project according to statistics
     - Parameter statistic: Statistic created with values from time tracker to be added to the total project time
     - Returns: Boolean value according to the sucess in updating the current project
     */
    func updateProject(statistic: Statistic) -> Bool{
        var success = true
        var project: Project?
        projectBO.retrieve { (result) in
            switch result {
            case .success(let projects):
                let filteredProject = projects.filter{$0.id == projectUuid}
                guard var dbProject = filteredProject.first else {return}
                dbProject += statistic
                project = dbProject
            case .failure(let error):
                print(error.localizedDescription)
                success = false
            }
        }
        guard let updatedProj = project else {return false}
        projectBO.update(project: updatedProj) { (result) in
            switch result {
            case .success(_): break
            case .failure(let error):
                print(error.localizedDescription)
                success = false
            }
        }
        return success
    }
    
    //TODO: put it in an Utils
    /**
     Method for getting the current date
     - Returns: Value containing current Year and Month
     */
    func getDate() -> DateComponents{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return components
    }
}
