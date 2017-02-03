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
        let pipe = Pipe()
        let file = pipe.fileHandleForReading
        let task = Process()
        
        task.launchPath = "/usr/bin/xcrun"
        task.arguments = []
        task.standardOutput = pipe
        
        task.launch()
        
        let data = file.readDataToEndOfFile()
        file.closeFile()
        
//        let output = String(data: data, encoding: String.Encoding.utf8)
//        print(output)
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
