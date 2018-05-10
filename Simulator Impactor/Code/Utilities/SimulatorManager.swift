//
//  SimulatorManager.swift
//  Simulator Impactor
//
//  Created by Jacob King on 03/02/2017.
//  Copyright © 2017 Militia Softworks Ltd. All rights reserved.
//

import Foundation
import Cocoa

class SimulatorManager {
    
    static let simulatorPathComponent = "Library/Developer/CoreSimulator/Devices/"
    
    static func fetchSimulators() -> [SimulatorModel] {
        var foundSimulators = [SimulatorModel]()
        
        let findTask = Process()
        let outPipe = Pipe()
        
        findTask.launchPath = "/usr/bin/xcrun"
        findTask.arguments = ["instruments", "-s"]
        findTask.standardOutput = outPipe
        findTask.launch()
        findTask.waitUntilExit()
        
        let fileHandle = outPipe.fileHandleForReading
        let dataRead = fileHandle.readDataToEndOfFile()
        if let stringRead = String(data: dataRead, encoding: String.Encoding.utf8) {
            let devicesString = stringRead.replacingOccurrences(of: "Known Devices:\n", with: "")
            let devicesArray = devicesString.components(separatedBy: "\n")
            print(devicesArray)
            
            for deviceString in devicesArray {
                guard deviceString.contains("Simulator") else {
                    continue // We only want simulators
                }
                let sim = SimulatorModel(launchString: deviceString)
                foundSimulators.append(sim)
            }
        }
        
        return foundSimulators
    }
    
    static func killRunningSimulators(onSuccessfulCompletion: ((_ process: Process) -> Void)? = nil) {
        let killTask = Process()
        killTask.launchPath = "/usr/bin/killall"
        killTask.arguments = ["iOS Simulator"]
        killTask.terminationHandler = { (process) in
            onSuccessfulCompletion?(process)
        }
        killTask.launch()
    }
    
    static func launchSimulator(sim: SimulatorModel, onSuccessfulCompletion: ((_ process: Process) -> Void)? = nil) {
        let launchTask = Process()
        launchTask.launchPath = "/usr/bin/xcrun"
        launchTask.arguments = ["instruments", "-w", sim.launchString]
        launchTask.terminationHandler = { (process) in
            // This can only go wrong if command line tools aren't installed, but we can pass the error through to install stage.
            onSuccessfulCompletion?(process)
        }
        launchTask.launch()
    }
    
    static func installApp(atPath appPath: URL, onSuccessfulCompletion: ((_ process: Process) -> Void)? = nil) {
        let installTask = Process()
        installTask.launchPath = "/usr/bin/xcrun"
        installTask.arguments = ["simctl", "install", "booted", appPath.path]
        installTask.terminationHandler = { (process) in
            if process.terminationStatus == 0 {
                // Success
                onSuccessfulCompletion?(process)
            } else {
                // Failure
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = "Error"
                    alert.informativeText = "Could not install app \"\(appPath.pathComponents.last!)\""
                    alert.addButton(withTitle: "Okay")
                    alert.runModal()
                }
            }
        }
        installTask.launch()
    }
    
    static func runApp(withBundleId bundleId: String, onSuccessfulCompletion: ((_ process: Process) -> Void)? = nil) {
        let runTask = Process()
        runTask.launchPath = "/usr/bin/xcrun"
        runTask.arguments = ["simctl", "launch", "booted", bundleId]
        runTask.terminationHandler = { (process) in
            if process.terminationStatus == 0 {
                // Success
                onSuccessfulCompletion?(process)
            } else {
                // Failure
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = "Error"
                    alert.informativeText = "Could not run app with bundle id \"\(bundleId)\""
                    alert.addButton(withTitle: "Okay")
                    alert.runModal()
                }
            }
        }
        runTask.launch()
    }
}
