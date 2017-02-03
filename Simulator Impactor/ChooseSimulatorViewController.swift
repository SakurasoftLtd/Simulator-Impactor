//
//  ChooseSimulatorViewController.swift
//  Simulator Impactor
//
//  Created by Jacob King on 03/02/2017.
//  Copyright © 2017 Cobalt Telephone Technologies. All rights reserved.
//

import Cocoa

class ChooseSimulatorViewController: NSViewController {
    
    @IBOutlet var simulatorListDropDown: NSPopUpButton!
    @IBOutlet var runButton: NSButton!
    @IBOutlet var selectIpaButton: NSButton!
    @IBOutlet var ipaLabel: NSTextField!
    
    var simulators = [SimulatorModel]()
    
    var selectedSimulator: SimulatorModel?
    var selectedIpa: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveSimulators()
    }
    
    func retrieveSimulators() {
        simulators = SimulatorManager.fetchSimulators()
        simulatorListDropDown.removeAllItems()
        simulatorListDropDown.addItem(withTitle: "- Please Select -")
        for sim in simulators {
            simulatorListDropDown.addItem(withTitle: sim.displayString)
        }
    }
    
    func openSimulatorWithApp() {
        
        
        extractBundleIdentifierFromIPA { (bundleId) in
            let launchTask = Process()
            launchTask.launchPath = "/usr/bin/xcrun"
            launchTask.arguments = ["instruments", "-w", self.selectedSimulator!.launchString]
            launchTask.launch()
            
            let installTask = Process()
            installTask.launchPath = "/usr/bin/xcrun"
            installTask.arguments = ["simctl", "install", "booted", self.selectedIpa!.path]
            installTask.launch()
            
            let runTask = Process()
            runTask.launchPath = "/usr/bin/xcrun"
            runTask.arguments = ["simctl", "launch", "booted", "com.ctt.co.uk.ringgo"]
            runTask.launch()
        }
    }
    
    func extractBundleIdentifierFromIPA(completion: @escaping (_ bundleId: String?) -> Void) {
        guard selectedIpa != nil else {
            completion(nil)
            return
        }
        
        var tempDir = NSTemporaryDirectory()
        tempDir = tempDir + "\(arc4random_uniform(2048)).ipa"
        
        let copyTask = Process()
        copyTask.launchPath = "/bin/cp"
        copyTask.arguments = ["-f", selectedIpa!.path, tempDir]
        copyTask.terminationHandler = { (task) in
            
            if task.terminationStatus == 0 {
                let unzipTask = Process()
                unzipTask.launchPath = "/usr/bin/unzip"
                unzipTask.arguments = ["-o", tempDir]
                unzipTask.terminationHandler = { (task) in
                    if task.terminationStatus == 0 {
                        let infoPlistPath = tempDir + "/Payload/Info.plist"
                        let plist = NSDictionary(contentsOfFile: infoPlistPath)
                        let bundleId = plist?.object(forKey: kCFBundleIdentifierKey) as? String
                        completion(bundleId)
                    }
                }
                unzipTask.launch()
            }
        }
        copyTask.launch()
    }
    
    @IBAction func simulatorSelected(_ sender: Any) {
        let selectedItemTitle = simulatorListDropDown.selectedItem!.title
        simulatorListDropDown.setTitle(selectedItemTitle)
        guard selectedItemTitle != "- Please Select -" else {
            return
        }
        
        selectedSimulator = simulators.filter { $0.displayString == selectedItemTitle }.first
    }
    
    @IBAction func runButtonPressed(_ sender: Any) {
        guard selectedSimulator != nil && selectedIpa != nil else {
            return
        }
        openSimulatorWithApp()
    }
    
    @IBAction func selectIpaButtonPressed(_ sender: Any) {
        let select = NSOpenPanel()
        select.title = "Choose .ipa"
        select.allowsMultipleSelection = false
        select.canChooseFiles = true
        select.canChooseDirectories = false
        select.canCreateDirectories = false
        select.allowedFileTypes = ["ipa"]
        if let selectedFileURL = select.runModal() == NSFileHandlingPanelOKButton ? select.urls.first : nil {
            // got file
            let fileName = selectedFileURL.pathComponents.last!
            ipaLabel.stringValue = fileName
            self.selectedIpa = selectedFileURL
        }
    }
}
