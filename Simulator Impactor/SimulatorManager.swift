//
//  SimulatorManager.swift
//  Simulator Impactor
//
//  Created by Jacob King on 03/02/2017.
//  Copyright © 2017 Cobalt Telephone Technologies. All rights reserved.
//

import Foundation
import Cocoa

class SimulatorManager {
    
    static let simulatorPathComponent = "Library/Developer/CoreSimulator/Devices/"
    
    static func fetchSimulators() -> [SimulatorModel] {
        let fileManager = FileManager.default
        var foundSimulators = [SimulatorModel]()
        
        do {
            let simulatorPath = fileManager.homeDirectory(forUser: NSUserName())!.appendingPathComponent(simulatorPathComponent)
            let simulatorFolders = try fileManager.contentsOfDirectory(at: simulatorPath, includingPropertiesForKeys: [], options: [.skipsHiddenFiles, .skipsPackageDescendants])
            
            for folderURL in simulatorFolders {
                
                if let devicePlist = NSDictionary(contentsOf: folderURL.appendingPathComponent("device.plist")) {
                    
                    var simModel = SimulatorModel()
                    simModel.name = devicePlist.object(forKey: "name") as? String ?? ""
                    simModel.udid = devicePlist.object(forKey: "UDID") as? String ?? ""
                    
                    if let runtime = devicePlist.object(forKey: "runtime") as? String {
                        let rawIosString = runtime.components(separatedBy: ".").last!
                        let iosVersion = rawIosString.replacingOccurrences(of: "iOS-", with: "iOS ").replacingOccurrences(of: "-", with: ".")
                        simModel.iosVersion = iosVersion
                    }
                    
                    foundSimulators.append(simModel)
                }
            }
            
        } catch {
            print("Path does not exist.")
        }
        foundSimulators.sort { (sim1, sim2) -> Bool in
            sim1.name > sim2.name
        }
        return foundSimulators
    }
}
