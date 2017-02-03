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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveSimulators()
    }
    
    func retrieveSimulators() {
        let sims = SimulatorManager.fetchSimulators()
        print(sims)
    }
    
    @IBAction func simulatorSelected(_ sender: Any) {
        
    }
    
    @IBAction func runButtonPressed(_ sender: Any) {
        
    }
}
