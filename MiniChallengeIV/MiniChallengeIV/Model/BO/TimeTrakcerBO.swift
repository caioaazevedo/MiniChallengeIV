//
//  TimeTrakcerBO.swift
//  MiniChallengeIV
//
//  Created by Fábio Maciel de Sousa on 29/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

///Class created for handling the count down
class TimeTracker {
    
    private var timer = Timer()
    let date = DateComponents()

    var isTrackingTime = false
    
    /**
     Method for starting the count down from an initial value, and also handling view updates.
     
     If another countDown has already started, a new one won't start.The initial value must be greater than 0
     
        - Parameter minutes: the initial value in minutes which the countDown will start from.
        - Parameter updateView: a closure called each time the timer is updated for handling view updates.
     */
    func startTimer(countDownFrom minutes: Int, updateView: @escaping (String) -> Void){
        if isTrackingTime {return}
        var countDown = minutes * 60
        isTrackingTime = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            countDown -= 1
            let convertedTime = self.secondsToString(with: countDown)
            updateView(convertedTime)
            if countDown == 0{
                self.isTrackingTime = false
                self.timer.invalidate()
            }
        })
    }
    
    /**
     Method for stopping the count down.
     
     if the count down was running it pop up a message to the user.
     */
    func stopTimer(updateView: @escaping () -> Void){
        if isTrackingTime{
            updateView()
        }
        timer.invalidate()
        isTrackingTime = false
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
