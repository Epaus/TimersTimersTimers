//
//  TimerPersistence.swift
//  Timers WatchKit Extension
//
//  Created by Estelle Paus on 11/24/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import Foundation
import os.log

struct TimerPersistence {
    
    
    func savePropertyList(updatedList: [TimerStruct]) {
        var plist = Dictionary<String, Array<TimerStruct>>()
        plist["list"] = updatedList
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
       

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("TimerList.plist")
        
        
        do {
            let data = try encoder.encode(plist)
            try data.write(to: path)
        } catch {
            os_log("Timer List failed encoding and writing - using original list")
        }
    }
    
    static func readPropertyList() -> [TimerStruct] {
        var timerStructArray = [TimerStruct]()
        
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destPath = (dir as NSString).appendingPathComponent("TimerList.plist")
        let url = URL(fileURLWithPath: destPath)
         
        let decoder = PropertyListDecoder()
        var dict: Dictionary<String, Array<TimerStruct>>?

        do {
        let data = try Data(contentsOf: url)
        try dict = decoder.decode(Dictionary<String, Array<TimerStruct>>.self, from: data)
        } catch {
        return timerStructArray
        }
        guard let myDict = dict else {
            return timerStructArray
        }

        guard let list = myDict["list"] else {
            return timerStructArray
        }
        timerStructArray = list
        return timerStructArray
    }
    
    func updatePropertyList(list: [ATimer]) {
        let structArray = modelToStruct(timerArray: list)
        savePropertyList(updatedList: structArray)
    }

    func modelToStruct(timerArray: [ATimer]) -> [TimerStruct] {
        var structArray = [TimerStruct]()
        for timer in timerArray {
            let newStruct = TimerStruct(title: timer.title, offsetSeconds: timer.offsetSeconds)
            structArray.append(newStruct)
        }
        return structArray
    }
}
