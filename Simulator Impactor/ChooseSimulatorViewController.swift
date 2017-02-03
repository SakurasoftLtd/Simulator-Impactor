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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveSimulators()
    }
    
    func retrieveSimulators() {
        let sims = SimulatorManager.fetchSimulators()
        simulatorListDropDown.removeAllItems()
        for sim in sims {
            simulatorListDropDown.addItem(withTitle: sim.displayString)
        }
    }
    
    @IBAction func simulatorSelected(_ sender: Any) {
        simulatorListDropDown.setTitle(simulatorListDropDown.selectedItem!.title)
    }
    
    @IBAction func runButtonPressed(_ sender: Any) {
        
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
        }
    }
}
