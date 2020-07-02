//
//  AlarmManager.swift
//  Timers WatchKit Extension
//
//  Created by Estelle Paus on 1/25/20.
//  Copyright © 2020 Paus Productions. All rights reserved.
//

import Foundation
import UserNotifications
import SwiftUI
import Combine

class AlarmManager: ObservableObject {
    static let shared = AlarmManager()
    var objectWillChange = ObservableObjectPublisher()
    

    var hapticTimer : Timer? = Timer()
    @Published var hapticRunning = false
    
    init() {
        
    }

func beginHapticAlert() {
    print("beginHapticAlert")
    hapticRunning = true
    objectWillChange.send()
      DispatchQueue.main.async {
          self.hapticTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector:(#selector(self.playHaptic)), userInfo: nil, repeats: true)
      }
  }
  
  func stopHaptic() {
    print("stopHaptic")
      if let timer =  hapticTimer  {
          timer.invalidate()
      }
    hapticRunning = false
  }
  
  @objc func playHaptic() {
    print("playHaptic")
    WKInterfaceDevice.current().play(.notification)
  }
}
