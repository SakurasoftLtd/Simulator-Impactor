//
//  SimulatorModel.swift
//  Simulator Impactor
//
//  Created by Jacob King on 03/02/2017.
//  Copyright © 2017 Militia Softworks Ltd. All rights reserved.
//

import Foundation

struct SimulatorModel {
    var iosVersion: String = ""
    var udid: String = ""
    var name: String = ""
    
    var displayString: String {
        return name + " (\(iosVersion))"
    }
    
    var launchString: String = ""
    
    init() { }
    
    init(launchString: String) {
        let iosVersionRegex = try! NSRegularExpression(pattern: "\\d+[.]\\d+([.]\\d+)?", options: [])
        if let match = iosVersionRegex.firstMatch(in: launchString, options: [], range: NSMakeRange(0, launchString.characters.count)) {
            self.iosVersion = NSString(string: launchString).substring(with: match.range)
        }
        
        let uuidRegex = try! NSRegularExpression(pattern: "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", options: .caseInsensitive)
        if let match = uuidRegex.firstMatch(in: launchString, options: [], range: NSMakeRange(0, launchString.characters.count)) {
            self.udid = NSString(string: launchString).substring(with: match.range)
        }
        
        if let deviceNameEndIndex = launchString.characters.index(of: "(") {
            self.name = launchString.substring(to: launchString.index(deviceNameEndIndex, offsetBy: -1))
        }
        
        self.launchString = launchString
    }
}
