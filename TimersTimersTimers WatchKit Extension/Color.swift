//
//  Color.swift
//  Timers WatchKit Extension
//
//  Created by Estelle Paus on 12/3/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import SwiftUI

extension Color {
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }

        // Scanner creation
        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
   
    static let teal: Color = Color(hex: "#11ABC1")
    static let cherry: Color = Color(hex: "#DF3062")
    static let mustard: Color = Color(hex: "#F5B935")
    static let timersGreen: Color = Color(hex: "#4BAC3F")
    static let darkGray: Color = Color(hex: "#151516")
    static let sunflowers: Color = Color(hex: "FFCE00")
    static let starryNight: Color = Color(hex: "0375B4")
    static let irises: Color = Color(hex: "007849")
    static let palm: Color = Color(hex: "1AAF41")
    static let embers: Color = Color(hex: "B82601")
    static let brightCoral: Color = Color(hex: "F53240")
    
    
    
    static let stopColor = Color.brightCoral
    static let doneColor = Color.starryNight
    static let pauseColor = Color.sunflowers
    static let goColor = Color.palm
    
}


