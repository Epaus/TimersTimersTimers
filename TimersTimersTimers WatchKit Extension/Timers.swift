//
//  Timers.swift
//  Timers WatchKit Extension
//
//  Created by Estelle Paus on 11/22/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import Foundation
import Combine

class Timers: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()

    
    @Published var timers = [ATimer]()
    
    init() {
        self.getTimerList()
    }
    
    func removeModel(index: Int) {
        var temp = self.timers
        temp.remove(at: index)
        self.timers = temp
        updateList()
    }

    
    func addModel(model: ATimer) {
        var temp = self.timers
        temp.append(model)
        self.timers = temp
        updateList()
        self.objectWillChange.send()
    }
    
    func updateList() {
        TimerPersistence().updatePropertyList(list: self.timers)
    }
    
    func lastIndex() -> Int {
        return self.timers.count - 1
    }
    
    func getTimerList() {
        let timerStructArray = TimerPersistence.readPropertyList()
        if timerStructArray.count == 0 {
            self.timers = [ATimer(offsetSeconds: 30, title: "30 seconds"), ATimer(offsetSeconds: 60, title: "1 minute"), ATimer(offsetSeconds: 180, title: "3 minutes"), ATimer(offsetSeconds: 300, title: "5 minutes"), ATimer(offsetSeconds: 3600, title: "1 hour")]
           
        } else {
            var tempList = [ATimer]()
            for timer in timerStructArray {
                let timerModel = ATimer(offsetSeconds: timer.offsetSeconds, title: timer.title)
                tempList.append(timerModel)
            }
            self.timers = tempList
        }
    }
}

