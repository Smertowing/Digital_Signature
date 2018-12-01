//
//  DSAViewController.swift
//  Digital_Signature
//
//  Created by Kiryl Holubeu on 11/24/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Cocoa

class DSAViewController: ViewController {

    @IBOutlet weak var qField: NSTextField!
    @IBOutlet weak var pField: NSTextField!
    @IBOutlet weak var hField: NSTextField!
    @IBOutlet weak var xField: NSTextField!
    @IBOutlet weak var kField: NSTextField!
    
    @IBOutlet weak var hashField: NSTextField!
    @IBOutlet weak var hashHexField: NSTextField!
    @IBOutlet weak var yField: NSTextField!
    @IBOutlet weak var gField: NSTextField!
    
    var q: BInt = 0
    var p: BInt = 0
    var h: BInt = 0
    var x: BInt = 0
    var k: BInt = 0
    
    var g: BInt = 0
    var y: BInt = 0
    
    var r: BInt = 0
    var hashVal: BInt = 0
    var s: BInt = 0
   
    var w: BInt = 0
    var u1: BInt = 0
    var u2: BInt = 0
    var v: BInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func mainStreamSuccessfull(for text: String, tag: BInt) -> Bool {
        switch tag {
        case 0:
            
            guard text.count > -1 else {
                dialogError(question: "Error!", text: "Please, open a file first.", type: .critical)
                return false
            }
            var hashStr = SHA1.hexString(from: text) ?? ""
            hashStr = hashStr.replacingOccurrences(of: " ", with: "").lowercased()
            guard hashStr != "" else {
                dialogError(question: "Error!", text: "Hash?", type: .critical)
                return false
            }
            hashVal = BInt(hashStr, radix: 16) ?? 0
            hashHexField.stringValue = hashStr
            hashField.stringValue = hashVal.description
            
            guard (BInt(qField.stringValue) != nil) && (BInt(qField.stringValue)!.bitWidth == 160) && (BInt(qField.stringValue)!.isPrime) else {
                dialogError(question: "Error!", text: "q is invalid number.", type: .critical)
                return false
            }
            q = BInt(qField.stringValue)!
            
            guard (BInt(pField.stringValue) != nil) && ((BInt(pField.stringValue)!-1)%q == 0) && ((BInt(pField.stringValue))!.bitWidth <= 1024) && ((BInt(pField.stringValue))!.bitWidth >= 512) && (BInt(pField.stringValue)!.isPrime) else {
                dialogError(question: "Error!", text: "p is invalid number.", type: .critical)
                return false
            }
            p = BInt(pField.stringValue)!
            
            guard (BInt(hField.stringValue) != nil) && (BInt(hField.stringValue)! > 1) && (BInt(hField.stringValue)! < (p-1)) else {
                dialogError(question: "Error!", text: "h is invalid number.", type: .critical)
                return false
            }
            h = BInt(hField.stringValue)!
            
            g = fastexp(h, (p-1)/q, p)
            guard g > 1 else {
                dialogError(question: "Error!", text: "g == 1.", type: .critical)
                return false
            }
            gField.stringValue = g.description
            
            guard (BInt(xField.stringValue) != nil) && (BInt(xField.stringValue)! > 0) && (BInt(xField.stringValue)! < q) else {
                dialogError(question: "Error!", text: "x is invalid number.", type: .critical)
                return false
            }
            x = BInt(xField.stringValue)!
            
            y = fastexp(g, x, p)
            yField.stringValue = y.description
            
            guard (BInt(kField.stringValue) != nil) && (BInt(kField.stringValue)! > 0) && (BInt(kField.stringValue)! < q) else {
                dialogError(question: "Error!", text: "k is invalid number.", type: .critical)
                return false
            }
            k = BInt(kField.stringValue)!
            
            r = fastexp(g, k, p) % q
            let sExp = fastexp(k, q-2, q)
            let sHash = hashVal+x*r
            s = (sExp * sHash) % q
            
            guard (r != 0) && (s != 0) else {
                dialogError(question: "Error!", text: "Enter other k!", type: .critical)
                return false
            }
    
        case 1:
            
            guard text.count > -1 else {
                dialogError(question: "Error!", text: "Please, open a file.", type: .critical)
                return false
            }
            var hashStr = SHA1.hexString(from: text) ?? ""
            hashStr = hashStr.replacingOccurrences(of: " ", with: "").lowercased()
            guard hashStr != "" else {
                dialogError(question: "Error!", text: "Hash?", type: .critical)
                return false
            }
            hashVal = BInt(hashStr, radix: 16) ?? 0
            hashHexField.stringValue = hashStr
            hashField.stringValue = hashVal.description
            
            guard openedSignatureDSA != nil else {
                dialogError(question: "Error!", text: "Please, open a signature.", type: .critical)
                return false
            }
            r = openedSignatureDSA!.0
            s = openedSignatureDSA!.1
            
            guard (BInt(qField.stringValue) != nil) && (BInt(qField.stringValue)!.bitWidth == 160) && (BInt(qField.stringValue)!.isPrime) else {
                dialogError(question: "Error!", text: "q is invalid number.", type: .critical)
                return false
            }
            q = BInt(qField.stringValue)!
            
            guard (BInt(pField.stringValue) != nil) && ((BInt(pField.stringValue)!-1)%q == 0) && ((BInt(pField.stringValue))!.bitWidth <= 1024) && ((BInt(pField.stringValue))!.bitWidth >= 512) && (BInt(pField.stringValue)!.isPrime) else {
                dialogError(question: "Error!", text: "p is invalid number.", type: .critical)
                return false
            }
            p = BInt(pField.stringValue)!
            
            guard (BInt(yField.stringValue) != nil) && (BInt(yField.stringValue)! > 0) else {
                dialogError(question: "Error!", text: "y is invalid number.", type: .critical)
                return false
            }
            y = BInt(yField.stringValue)!
        
            guard (BInt(gField.stringValue) != nil) && (BInt(gField.stringValue)! > 1) else {
                dialogError(question: "Error!", text: "g <= 1.", type: .critical)
                return false
            }
            g = BInt(gField.stringValue)!
            
            w = fastexp(s,q-2,q)
            u1 = (hashVal * w) % q
            u2 = (r * w) % q
            v = ((fastexp(g, u1, p) * fastexp(y, u2, p))%p)%q
            
        default:
            return false
        }
        
        return true
    }

    
    @IBAction func openAction(_ sender: Any) {
        openTextFile()
    }
    
    @IBAction func createAction(_ sender: Any) {
        if let openedText = openedFile {
            if mainStreamSuccessfull(for: openedText, tag: 0) {
                openedSignatureDSA = (r,s)
                if let signedText = writeSignatureDSA() {
                    saveTextFile(signedMessage: signedText)
                }
            }
        }
    }
    
    @IBAction func checkAction(_ sender: Any) {
        if let rawText = readSignatureDSA() {
            if mainStreamSuccessfull(for: rawText, tag: 1) {
                if v == r {
                    dialogError(question: "Signature checked", text: "Result: Valid", type: .informational)
                } else {
                    dialogError(question: "Signature checked", text: "Result: Invalid", type: .informational)
                }
            }
        }
    }
    
   
    
}
