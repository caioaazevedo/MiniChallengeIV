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
    var configTime = 25
    var hasEnded = false
    var timeInterval : TimeInterval = 1 //seconds at a time
    
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
    var state = TimeTrackerState.focus
    var changeCicle: TimeTrackerState{
        self.focusTime = 0
        self.lostFocusTime = 0
        self.restTime = 0
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
                self.state = self.changeCicle
                self.timer.invalidate()
                //TODO: update statistics
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
        state = .focus
        updateView()
    }
    
    /**
     Method for converting seconds to the formatted string to be displayed on the view
        - Parameter seconds: the current unformatted second from the count down
        - Returns: formatted string of the current time in minutes and seconds
     */
    func secondsToString(with seconds: Int) -> String{
        if seconds < 0 {return ""} //TODO: send error
        let min = (seconds / 60) % 60
        let sec = seconds % 60
        return String(format:"%02i:%02i", min, sec)
    }
    
    /**
     Method for converting strings to seconds
        - Parameter text: the text from the label in the view
        - Returns: the amount of seconds for the count down
     */
    func stringToSeconds(with text: String) -> Int{
        if text.contains("-") { return 0}
        let numbers = text.split(separator: ":")
        guard let firstNumbers = numbers.first else {return 0}
        guard let min = Int(firstNumbers) else {return 0}
        let sec = min * 60
        return sec
    }
    
    //TODO
    func updateStatistics() {
        /// Updates on Databsse
    }
    
}
