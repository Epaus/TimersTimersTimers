//
//  CountdownDisplay.swift
//  Timers WatchKit Extension
//
//  Created by Estelle Paus on 11/14/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import SwiftUI
import Combine


struct CountdownDisplay: View {
    @ObservedObject var model : ATimer
    @State var showButtons : Bool = false
    
    
    var body: some View {
        ZStack {
            (model.timerRunning || model.timerDone ? Color.darkGray : Color.clear)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Spacer()
                Text(model.title)
                Spacer()
                HStack {
                    Spacer()
                    Text( String(format: "%02d :", model.hours as Int) )
                    Text(String(format: "%02d :", model.minutes as Int) )
                    Text(String(format: "%02d", model.seconds as Int) )
                    Spacer()
                }
                Spacer()
                if (model.timerDone && !model.timerRunning) {
                    Text("Timer Done")  .foregroundColor(Color.doneColor)
                }
                
                if (!model.startState && (model.timerDone || model.timerRunning || model.timerPaused)) {
                    GeometryReader { proxy in
                    
                      if proxy.size.width > 324.0/2.0 { 
                        HStack44View(model: self.model)
                      } else {
                        HStack40View(model: self.model)
                      }
                    }
                }
                Spacer()
                Spacer()
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(model.borderColor, lineWidth: model.timerRunning == true ? 8 : 6)
                .padding(.all, 0.0)
        )
    }
}


struct CountdownDisplay_Previews: PreviewProvider {
    static var previews: some View {
        CountdownDisplay(model: ATimer(offsetSeconds: 60, title: "1 minute"))
    }
}
