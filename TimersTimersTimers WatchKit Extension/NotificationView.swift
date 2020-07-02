//
//  NotificationView.swift
//  Timers WatchKit Extension
//
//  Created by Estelle Paus on 11/12/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import SwiftUI

struct NotificationView: View {
   let title: String
   let message: String
   
   
   init(title: String,
        message: String) {
       self.title = title
       self.message = message
   }
   
        var body: some View {
        VStack {
            
            
            Text(title )
                .font(.headline)
                .lineLimit(0)
            
            Divider()
            
            Text("Timer Done")
                .font(.caption)
                .lineLimit(0)
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(title: "One Minute", message: "Timer Done")
    }
}
