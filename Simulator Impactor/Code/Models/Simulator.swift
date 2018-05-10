//
//  Simulator.swift
//  Simulator Impactor
//
//  Created by Jacob King on 03/02/2017.
//  Copyright © 2017 Militia Softworks Ltd. All rights reserved.
//

import Foundation

struct Simulator {
    var iosVersion: String = ""
    var udid: String = ""
    var name: String = ""
    
    var displayString: String {
        return name + " (\(iosVersion))"
    }
    
    var launchString: String = ""
    
    init() { }
    
    init?(launchString: String) {
        
        guard
            let iosVersionRegex = try? NSRegularExpression(pattern: "\\d+[.]\\d+([.]\\d+)?", options: []),
            let uuidRegex = try? NSRegularExpression(pattern: "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", options: .caseInsensitive)
        else {
            return nil
        }
        
        guard
            let iosVerRange = iosVersionRegex.firstMatch(in: launchString, options: [], range: NSMakeRange(0, launchString.count)),
            let udidRange = uuidRegex.firstMatch(in: launchString, options: [], range: NSMakeRange(0, launchString.count)),
            let deviceNameEndIndex = launchString.index(of: "(")
        else {
            return nil
        }
        
        self.name = String(launchString[..<deviceNameEndIndex])
        self.iosVersion = NSString(string: launchString).substring(with: iosVerRange.range) as String
        self.udid = NSString(string: launchString).substring(with: udidRange.range) as String
        self.launchString = launchString
    }
}
