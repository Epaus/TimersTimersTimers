//
//  ATimer.swift
//  MyTimers WatchKit Extension
//
//  Created by Estelle Paus on 10/9/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import Foundation
import UserNotifications
import os.log
import SwiftUI
import Combine


class ATimer: Identifiable, ObservableObject {
    
    @ObservedObject var alarmManager = AlarmManager.shared
    var id = UUID()
    let didChange = PassthroughSubject<Void, Never>()
    var offsetSeconds : Int
    var timerValueAsOffsetSeconds: Int
    var finalTime : Date!
    var title : String
    var timerIdentifer: String
    var cancelled : Bool = false
    @Published var lastDateUsed = Date()
    
    @Published var runningTimerBackgroundColor: Color = .darkGray
    @Published var timerDone: Bool = false
    @Published var timerRunning: Bool = false
    @Published var timerPaused: Bool = false
    @Published var startState: Bool = true
    @Published var hours: Int {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send()
            }
        }
    }
    @Published var minutes: Int {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send()
            }
        }
    }
    @Published var seconds: Int {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send()
            }
        }
    }
    @Published var timeLeft: Int = 100000
                    
    let pauseText = "  Pause"
    let cancelText = "Cancel"
    let stopText = "Stop"
    let resumeText = "  Start"
    let repeatText = "Repeat"
                     

    @Published var countdownDisplayTextLeft: String
    @Published var countdownDisplayTextRight: String
    @Published var countdownDisplayColorLeft: Color = .stopColor
    @Published var countdownDisplayColorRight: Color = .pauseColor
    @Published var borderColor: Color = .gray
   
    var timer: Timer?
    
    
    init(offsetSeconds: Int, title: String?) {
        self.title = title ?? ""
        self.timerIdentifer = self.title + "-timerDone"
        self.cancelled = false
        self.offsetSeconds = offsetSeconds
        self.timerValueAsOffsetSeconds = offsetSeconds
        let userCalendar = NSCalendar.current
        let now = Date()
        finalTime = userCalendar.date(byAdding: .second, value:self.offsetSeconds, to: now)
        
        let diff = ceil(self.finalTime.timeIntervalSinceNow)
        self.timeLeft = Int(diff)
        if (diff < 0.5) {
            self.hours = 0
            self.minutes = 0
            self.seconds = 0
            self.offsetSeconds = 0
        } else {
            self.offsetSeconds = Int(diff)
        }
        
        let durationDate = NSDate(timeIntervalSince1970: diff)
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        hourFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.hours = Int(hourFormatter.string(from: durationDate as Date))!
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        minuteFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.minutes = Int(minuteFormatter.string(from: durationDate as Date))!
        
        let secondFormatter = DateFormatter()
        secondFormatter.dateFormat = "ss"
        secondFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.seconds = Int(secondFormatter.string(from: durationDate as Date))!
        
        self.timerPaused = false
        self.timerRunning = false
        self.timerDone = false
        self.startState = true
        self.countdownDisplayTextLeft = self.cancelText
        self.countdownDisplayTextRight = self.pauseText
    }
    
    init(hours: Int, minutes: Int, seconds: Int, title: String) {
        let minInSec = minutes * 60
        let hourInSec = hours * 3600
        self.offsetSeconds = minInSec + hourInSec + seconds
        self.title = title
        self.timerIdentifer = self.title + "-timerDone"
        self.cancelled = false
        self.timerValueAsOffsetSeconds = offsetSeconds
        let userCalendar = NSCalendar.current
        let now = Date()
        finalTime = userCalendar.date(byAdding: .second, value:self.offsetSeconds, to: now)
        
        let diff = ceil(self.finalTime.timeIntervalSinceNow)
        self.timeLeft = Int(diff)
        if (diff < 0.5) {
            self.hours = 0
            self.minutes = 0
            self.seconds = 0
            self.offsetSeconds = 0
            NotificationCenter.default.post(name: .timerDoneNotification, object: nil )
        } else {
            self.offsetSeconds = Int(diff)
        }
        
        let durationDate = NSDate(timeIntervalSince1970: diff)
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        hourFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.hours = Int(hourFormatter.string(from: durationDate as Date))!
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        minuteFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.minutes = Int(minuteFormatter.string(from: durationDate as Date))!
        
        let secondFormatter = DateFormatter()
        secondFormatter.dateFormat = "ss"
        secondFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.seconds = Int(secondFormatter.string(from: durationDate as Date))!
        
        self.timerPaused = false
        self.timerRunning = false
        self.timerDone = false
        self.startState = true
        self.countdownDisplayTextLeft = self.cancelText
        self.countdownDisplayTextRight = self.pauseText
        
        self.start()
        
    }
    
    func setFinalTime() {
        let userCalendar = NSCalendar.current
        let now = Date()
        finalTime = userCalendar.date(byAdding: .second, value:self.offsetSeconds, to: now)
    }
    
    func getOffSetSeconds(hours: Int, minutes: Int, seconds: Int) -> Int {
        let minInSec = minutes * 60
        let hourInSec = hours * 3600
        return minInSec + hourInSec + seconds
    }
    
    public func getTimeDifference() ->TimeInterval {
        return self.finalTime.timeIntervalSinceNow
    }
    
    public func setTimeDifferenceValues() {
        
        let diff = ceil(getTimeDifference())
        
        self.timeLeft = Int(diff)
        if (diff < 0.5) {
            print("diff = ",diff)
            self.hours = 0
            self.minutes = 0
            self.seconds = 0
            self.offsetSeconds = 0
            stop()
            self.alarmManager.beginHapticAlert()
           
            self.countdownDisplayTextLeft = self.stopText
            self.countdownDisplayColorLeft = .stopColor
            self.countdownDisplayTextRight = self.repeatText
            self.countdownDisplayColorRight = .goColor
        } else {
            self.offsetSeconds = Int(diff)
        }
        
        setTimeComponents(offset: diff)
    }
    
    func setTimeComponents(offset: Double) {
        let durationDate = NSDate(timeIntervalSince1970: offset)
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        hourFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.hours = Int(hourFormatter.string(from: durationDate as Date))!
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        minuteFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.minutes = Int(minuteFormatter.string(from: durationDate as Date))!
        
        let secondFormatter = DateFormatter()
        secondFormatter.dateFormat = "ss"
        secondFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.seconds = Int(secondFormatter.string(from: durationDate as Date))!
    }
    
    func start(withCompletionHandler completionHandler:  () -> Void) {
        self.start()
        completionHandler()
    }
        
    func start() {
        if self.offsetSeconds == 0 {
            return
        }
        if !self.timerPaused {
            self.reset()
        }
        self.timerRunning = true
        self.lastDateUsed = Date()
        self.setFinalTime()
        sendNotification()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if self.timer != nil && self.timerRunning == true {
                self.setTimeDifferenceValues()
            }
        }
        self.timerDone = false
        self.timerPaused = false
        self.startState = false
        self.borderColor = .goColor
        self.countdownDisplayTextLeft = self.cancelText
        self.countdownDisplayTextRight = self.pauseText
        
    }
    
    func cancelRun() {
        stop()
        cancelNotification()
    }
    
    func stop() {
        DispatchQueue.main.async {
            guard let t = self.timer else { return }
            t.invalidate()
            self.timer = nil
            self.timerDone = true
            self.timerRunning = false
            self.offsetSeconds = self.timerValueAsOffsetSeconds
            self.setTimeComponents(offset: Double(self.timerValueAsOffsetSeconds))
            self.borderColor = .gray
            self.objectWillChange.send()
        }
    }
    
    func pauseTimer() {
        DispatchQueue.main.async {
            guard let t = self.timer else { return }
            t.invalidate()
            self.timerDone = false
            self.timerRunning = false
            self.cancelNotification()
            
            self.countdownDisplayTextRight = self.resumeText
            self.countdownDisplayColorRight = .goColor
            self.timerPaused = true
            self.startState = false
        }
    }
    
    func resumeTimer() {
        self.setFinalTime()
        self.sendNotification()
        self.countdownDisplayTextRight = pauseText
        self.countdownDisplayColorRight = .pauseColor
        self.startState = false
        self.timerRunning = true
        self.start()
        self.timerPaused = false
        
    }
    
    func endTimer() {
        self.stop()
        DispatchQueue.main.async {
            self.timerDone = false
            self.timerRunning = false
            self.timerPaused = false
            self.startState = true
            self.offsetSeconds = self.timerValueAsOffsetSeconds
            self.setTimeComponents(offset: Double(self.timerValueAsOffsetSeconds))
            self.countdownDisplayTextRight = self.pauseText
            self.countdownDisplayColorRight = .pauseColor
            self.objectWillChange.send()
        }
    }
    
    
    func reset() {
        guard let t = self.timer else { return }
        t.invalidate()
        self.timer = nil
        self.timerDone = false
        self.timerRunning = false
        self.timerPaused = false
        self.startState = true
        self.offsetSeconds = self.timerValueAsOffsetSeconds
        self.setTimeComponents(offset: Double(self.offsetSeconds))
        self.countdownDisplayTextRight = self.pauseText
        self.countdownDisplayColorRight = .pauseColor
        self.countdownDisplayTextLeft = self.cancelText
        self.countdownDisplayColorLeft = .stopColor
    }
    
    public func sendNotification() {
        let content = UNMutableNotificationContent()
        var notificationTitle : String
        if self.title == "" {
            notificationTitle = "Timer Done"
        } else {
            notificationTitle = self.title
        }
        
        content.body = NSString.localizedUserNotificationString(forKey: notificationTitle,
                                                                arguments: nil)
        
        content.title = NSString.localizedUserNotificationString(forKey: "Timer Done", arguments: nil)
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(self.timerValueAsOffsetSeconds), repeats: false)
        
        let request = UNNotificationRequest(identifier: timerIdentifer, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if error != nil {
                os_log("error adding notification request: ")
            } 
        }
        
    }
    
    func cancelNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [timerIdentifer])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        if notification.request.identifier == self.timerIdentifer {
            completionHandler( [.alert,.sound,.badge])
            print("in willPresentNotification")
        }
    }
}


