//
//  CreateTimer.swift
//  Timers WatchKit Extension
//
//  Created by Estelle Paus on 10/15/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import SwiftUI

struct CreateTimer: View {
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var selectedSecond: Int = 0
    @State private var hour: Int = 0
    @State private var minute: Int = 0
    @State private var second: Int = 0
    @State private var title: String = ""
    @State private var readyToTransition: Bool = false
    
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject var timers: Timers
    
    private var hourIncrements = Array(0...23)
    private var secMinIncrements = Array(0...59)
    
   
    
    var body: some View {
        
         VStack(alignment: .center) {
           
            HStack(alignment: .center) {
                       Picker(selection: $selectedHour, label:Text("Hrs")) {
                           ForEach(0 ..< hourIncrements.count) {
                            Text(String(format: "%02d", self.hourIncrements[$0]))
                           }
                }
                       Text(":")
                       Picker(selection: $selectedMinute, label:Text("Min")) {
                           ForEach(0 ..< secMinIncrements.count) {
                            Text(String(format: "%02d", self.secMinIncrements[$0]))
                           }
                       }
                       Text(":")
                       Picker(selection: $selectedSecond, label:Text("Sec")) {
                           ForEach(0 ..< secMinIncrements.count) {
                               Text(String(format: "%02d", self.secMinIncrements[$0]))
                           }
                       }
            } .pickerStyle(WheelPickerStyle()) .accentColor(.goColor)
               
            
            TextField("Timer title:", text: $title)
            
            Spacer()
            Spacer()
            
            HStack {
                Spacer()
                 Button(action: {
                     self.presentation.wrappedValue.dismiss()
                }, label: {
                    Button(action: {
                        
                        self.hour = self.selectedHour
                        self.minute = self.selectedMinute
                        self.second = self.selectedSecond
                        if self.hour > 0 || self.minute > 0 || self.second > 0 {
                            let newModel = ATimer(hours: self.hour, minutes: self.minute, seconds: self.second, title: self.title)
                            newModel.timerRunning = true
                            self.timers.addModel(model: newModel)
                            newModel.start()
                        }
                        self.presentation.wrappedValue.dismiss()
                        
                    }) {
                        ButtonView(title: "Start")
                    } .background(Color.goColor)
                      .cornerRadius(15)
                    .padding(-8)
                })
                
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                }) {
                    ButtonView(title: "Cancel")
                } .background(Color.stopColor)
                  .cornerRadius(15)
                
                Spacer()
                }
        } .navigationBarBackButtonHidden(true)
                   
    }
    
    func leadingZero(num: Int) -> String {
        let number = NSNumber(value: num)
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        guard let fixedNum = formatter.string(from: number) else { return "00" }
        return fixedNum
    }
}

struct ButtonView: View {
    var title: String = ""
    var body: some View {
        Text(title)
           .frame(width: 70, height: 40, alignment: .center)
            .foregroundColor(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTimer().environmentObject(Timers())
    }
}

