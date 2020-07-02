//
//  HStack40View.swift
//  Timers WatchKit Extension
//
//  Created by Estelle Paus on 12/5/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import SwiftUI

struct HStack40View: View {
    @ObservedObject var model : ATimer
    var body: some View {
    HStack {
        Spacer()
        Button(action: {}) {
            Text(self.model.countdownDisplayTextLeft)
                .foregroundColor(model.countdownDisplayColorLeft)
            
        } .onTapGesture {
            if (self.model.timerRunning == true) {
                self.model.cancelNotification()
            } else {
                self.model.alarmManager.stopHaptic()
            }
            self.model.endTimer()
        }
        
        Spacer()
        Button(action: {}) {
            Text(model.countdownDisplayTextRight)
                .foregroundColor(model.countdownDisplayColorRight)
            
            
        } .onTapGesture {
            if self.model.timerDone == true {
                self.model.alarmManager.stopHaptic()
            }
            if self.model.timerRunning == true {
                self.model.pauseTimer()
            } else {
                self.model.resumeTimer()
            }
        }
        
        Spacer()
    }    }
}

struct HStack40View_Previews: PreviewProvider {
    static var previews: some View {
        HStack40View(model: ATimer(offsetSeconds: 60, title: "1 minute"))
    }
}
