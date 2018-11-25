//
//  ViewController.swift
//  Digital_Signature
//
//  Created by Kiryl Holubeu on 11/11/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Cocoa

extension NSViewController {
    func browseFile() -> String {
        let browse = NSOpenPanel();
        browse.title                   = "Choose a file"
        browse.showsResizeIndicator    = true
        browse.showsHiddenFiles        = false
        browse.canCreateDirectories    = true
        browse.allowsMultipleSelection = false
        
        if (browse.runModal() == NSApplication.ModalResponse.OK) {
            let result = browse.url
            if (result != nil) {
                return result!.path
            }
        }
        return ""
    }
    
    func dialogError(question: String, text: String) {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }
}

class ViewController: NSViewController {
    
    var openedFile: String?
    var openedSignature: (Int, Int)?
    
    func openTextFile() {
        let fileURL = URL(fileURLWithPath: browseFile())
        if fileURL != URL(fileURLWithPath: "") {
            do {
                openedFile  = try String(contentsOf: fileURL)
            } catch {
                dialogError(question: "Failed reading from URL: \(fileURL)", text: "Error: " + error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

