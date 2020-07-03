//
//  TimerList.swift
//  Timers WatchKit Extension
//
//  Created by Estelle Paus on 11/12/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import SwiftUI

struct TimerList: View {
    @EnvironmentObject var timers: Timers
    @State var currentIndex = 0.0
    @State var items = [ATimer]()
    
    
    var body: some View {
        VStack {
            List
                {
                    HStack {
                                   Spacer()
                        NavigationLink(destination: CreateTimer().environmentObject(self.timers), label: {Text("Add Timer")})
                                   Spacer()
                               }
                    ForEach(items) { timer in
                    

                        CountdownDisplay(model: timer)
                        
                        .onTapGesture(perform: {
                            timer.start(withCompletionHandler: {
                                self.reload()
                            })
                        })
                    
                    
                    
                } .onDelete(perform: delete) }
                .onReceive(timers.objectWillChange, perform: { _ in
                    self.reload()
                })

                .onAppear(perform: {
                    self.reload()
                })
                .listStyle(CarouselListStyle())
        }
        
    }
    
    private func delete(at offsets: IndexSet) {
        
        guard let index = Array(offsets).first else { return }
        timers.timers.sort(by: { $0.lastDateUsed > $1.lastDateUsed })
        timers.removeModel(index: index)
        self.reload()
    }
    
    private func reload() {
        
        self.items = timers.timers.map({ ($0) })
        
       self.items.sort(by: { $0.timeLeft < $1.timeLeft && $0.timerRunning == true })
        for timer in items {
            if timer.timerRunning == true {
                _ = CountdownDisplay(model: timer)
            }
        }
        let timer = items[0]
        print(timer.timeLeft)
        _ = CountdownDisplay(model: timer)
    }
    
    func goToIndex(index: Int) {

        let timer = items[index]
        print(timer.timeLeft)
        _ = CountdownDisplay(model: timer)
    }
}

struct TimerList_Previews: PreviewProvider {
    static var previews: some View {
        AnyView(TimerList().environmentObject(Timers()))
    }
}


