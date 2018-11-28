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
    
    func dialogError(question: String, text: String, type: NSAlert.Style) {
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
    var openedSignatureDSA: (BInt, BInt)?
    
    func openTextFile() {
        let fileURL = URL(fileURLWithPath: browseFile())
        if fileURL != URL(fileURLWithPath: "") {
            do {
                openedFile  = try String(contentsOf: fileURL)
            } catch {
                dialogError(question: "Failed reading from URL: \(fileURL)", text: "Error: " + error.localizedDescription, type: .critical)
            }
        }
    }
    
    func saveTextFile(signedMessage text: String) {
        let fileURL = URL(fileURLWithPath: browseFile())
        if fileURL != URL(fileURLWithPath: "") {
            do {
                try text.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                dialogError(question: "Failed writing to URL \(fileURL)", text: "Error: " + error.localizedDescription, type: .critical)
            }
        }
    }
    
    func readSignatureDSA() -> String? {
        openedSignatureDSA = nil
        if var tempString = openedFile {
            if let keyIndex = tempString.lastIndex(of: "⚿") {
                let keyString = tempString[keyIndex..<tempString.endIndex]
                if let spaceIndex = keyString.firstIndex(of: " ") {
                    var firstKey = keyString[keyString.startIndex..<spaceIndex]
                    var secondKey = keyString[spaceIndex..<keyString.endIndex]
                    firstKey.removeFirst()
                    secondKey.removeFirst()
                    
                    if let first = BInt(String(firstKey)), let second = BInt(String(secondKey)) {
                        openedSignatureDSA = (first,second)
                    } else {
                        return nil
                    }
                }
                tempString.removeSubrange(keyIndex..<tempString.endIndex)
                return tempString
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func writeSignatureDSA() -> String? {
        if var tempString = openedFile, let tempSignature = openedSignatureDSA {
            tempString.append("⚿"+String(tempSignature.0)+" "+String(tempSignature.1))
            return tempString
        } else {
            return nil
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

