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
    case running
    case pause
}

///Class created for handling the count down
class TimeTracker {
    //MARK:Atributes
    private var timer = Timer()
    let date = DateComponents()
    var timeValue = 5
    
    //MARK:Properties
    private var convertedTimeValue: Int{
        if state == .pause{
            return (timeValue / 5) * 60
        }
        return timeValue * 60
    }
    //MARK:States
    var state = TimeTrackerState.focus{
        didSet{
            lastState = oldValue
        }
    }
    private var lastState = TimeTrackerState.focus
    private var changeCicle: TimeTrackerState{
        return lastState == .focus ? .pause : .focus
    }
    //MARK: Methods
    /**
     Method for starting the count down from an initial value, and also handling view updates.
     
     If another countDown has already started, a new one won't start.The initial value must be greater than 0
     
        - Parameter minutes: the initial value in minutes which the countDown will start from.
        - Parameter updateView: a closure called each time the timer is updated for handling view updates.
     */
    func startTimer(updateView: @escaping (String, Bool) -> Void){
        if state == .running {return}
        var countDown = convertedTimeValue
        state = .running
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            countDown -= 1
            let convertedTimeText = self.secondsToString(with: countDown)
            if countDown == 0{
                self.state = self.changeCicle
                self.timer.invalidate()
                let defaultTimeText = self.secondsToString(with: self.convertedTimeValue)
                updateView(defaultTimeText ,true)
            }else{
                updateView(convertedTimeText,false)
            }
        })
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
        let numbers = text.split(separator: ":")
        guard let firstNumbers = numbers.first else {return 0}
        guard let min = Int(firstNumbers) else {return 0}
        let sec = min * 60
        return sec
    }
    
}
