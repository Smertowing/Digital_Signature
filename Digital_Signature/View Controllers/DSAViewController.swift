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
    @IBOutlet weak var yField: NSTextField!
    @IBOutlet weak var gField: NSTextField!
    
    var q: Int = 0
    var p: Int = 0
    var h: Int = 0
    var x: Int = 0
    var k: Int = 0
    
    var g: Int = 0
    var y: Int = 0
    
    var r: Int = 0
    var hashVal: BInt = 0
    var s: Int = 0
   
    var w: Int = 0
    var u1: Int = 0
    var u2: Int = 0
    var v: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func mainStreamSuccessfull(for text: String, tag: Int) -> Bool {
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
            hashField.stringValue = hashVal.description
            
            guard (Int(qField.stringValue) != nil) && (Int(qField.stringValue)!.isPrime) else {
                dialogError(question: "Error!", text: "q is invalid number.", type: .critical)
                return false
            }
            q = Int(qField.stringValue)!
            
            guard (Int(pField.stringValue) != nil) && (Int(pField.stringValue)!.isPrime) && ((Int(pField.stringValue)!-1)%q == 0) else {
                dialogError(question: "Error!", text: "p is invalid number.", type: .critical)
                return false
            }
            p = Int(pField.stringValue)!
            
            guard (Int(hField.stringValue) != nil) && (Int(hField.stringValue)! >= 1) && (Int(hField.stringValue)! <= (p-1)) else {
                dialogError(question: "Error!", text: "h is invalid number.", type: .critical)
                return false
            }
            h = Int(hField.stringValue)!
            
            g = fastexp(a: h, z: (p-1)/q, n: p)
            guard g > 1 else {
                dialogError(question: "Error!", text: "g <= 1.", type: .critical)
                return false
            }
            gField.stringValue = String(g)
            
            guard (Int(xField.stringValue) != nil) && (Int(xField.stringValue)! >= 0) && (Int(xField.stringValue)! <= q) else {
                dialogError(question: "Error!", text: "x is invalid number.", type: .critical)
                return false
            }
            x = Int(xField.stringValue)!
            
            y = fastexp(a: g, z: x, n: p)
            yField.stringValue = String(y)
            
            guard (Int(kField.stringValue) != nil) && (Int(kField.stringValue)! >= 0) && (Int(kField.stringValue)! <= q) else {
                dialogError(question: "Error!", text: "k is invalid number.", type: .critical)
                return false
            }
            k = Int(kField.stringValue)!
            
            r = fastexp(a: g, z: k, n: p) % q
            let sExp = fastexp(a: k, z: q-2, n: q)
            let tempHash = hashVal+x*r
            let sHash = tempHash % BInt(q)
            s = sExp * Int(sHash)
            
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
            hashField.stringValue = hashVal.description
            
            guard openedSignatureDSA != nil else {
                dialogError(question: "Error!", text: "Please, open a signature.", type: .critical)
                return false
            }
            r = openedSignatureDSA!.0
            s = openedSignatureDSA!.1
            
            guard (Int(qField.stringValue) != nil) && (Int(qField.stringValue)!.isPrime) else {
                dialogError(question: "Error!", text: "q is invalid number.", type: .critical)
                return false
            }
            q = Int(qField.stringValue)!
            
            guard (Int(pField.stringValue) != nil) && (Int(pField.stringValue)!.isPrime) && ((Int(pField.stringValue)!-1)%q == 0) else {
                dialogError(question: "Error!", text: "p is invalid number.", type: .critical)
                return false
            }
            p = Int(pField.stringValue)!
            
            guard (Int(hField.stringValue) != nil) && (Int(hField.stringValue)! >= 1) && (Int(hField.stringValue)! <= (p-1)) else {
                dialogError(question: "Error!", text: "h is invalid number.", type: .critical)
                return false
            }
            h = Int(hField.stringValue)!
            
            guard (Int(yField.stringValue) != nil) && (Int(yField.stringValue)! > 0) else {
                dialogError(question: "Error!", text: "y is invalid number.", type: .critical)
                return false
            }
            y = Int(yField.stringValue)!
            
            g = fastexp(a: h, z: (p-1)/q, n: p)
            guard g > 1 else {
                dialogError(question: "Error!", text: "g <= 1.", type: .critical)
                return false
            }
            gField.stringValue = String(g)
            
            w = fastexp(a: s, z: q-2, n: q)
            u1 = Int((hashVal * w) % q)
            u2 = (r * w) % q
            v = Int((((BInt(g) ** u1) * (BInt(y) ** u2)) % p) % q)
            
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
                    dialogError(question: "Signature checked", text: "Result: Valid", type: .informational)
                }
            }
        }
    }
    
   
    
}
