//
//  HostingController.swift
//  Timers WatchKit Extension
//
//  Created by Estelle Paus on 11/12/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import Combine

class HostingController: WKHostingController<AnyView> {
    
    override var body: AnyView {
        AnyView(TimerList().environmentObject(Timers()))
    }
}
