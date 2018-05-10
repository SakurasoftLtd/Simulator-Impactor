//
//  Utilities.swift
//  Simulator Impactor
//
//  Created by Jacob King on 08/02/2017.
//  Copyright © 2017 Militia Softworks Ltd. All rights reserved.
//

import Cocoa

class Utilities {
    
    static func extractBundleIdentifierFromApp(app: URL) -> String? {
        let infoPlistPath = app.path + "/Info.plist"
        let plist = NSDictionary(contentsOfFile: infoPlistPath)
        let bundleId = plist?.object(forKey: kCFBundleIdentifierKey) as? String
        return bundleId
    }
    
    static func openPanelForAppFileType(withExitHandler handler: ((_ file: URL?) -> Void)? = nil) {
        let select = NSOpenPanel()
        select.title = "Choose .app"
        select.allowsMultipleSelection = false
        select.canChooseFiles = true
        select.canChooseDirectories = false
        select.canCreateDirectories = false
        select.allowedFileTypes = ["app"]
        if let selectedFileURL = select.runModal() == NSFileHandlingPanelOKButton ? select.urls.first : nil {
            // got file
            handler?(selectedFileURL)
        } else {
            handler?(nil)
        }
    }
}
