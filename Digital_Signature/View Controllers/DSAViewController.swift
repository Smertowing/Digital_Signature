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
    var hashStr: String = ""
    var s: Int = 0
   
    var w: Int = 0
    var u1: Int = 0
    var u2: Int = 0
    var v: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func mainStreamSuccessfull(tag: Int) -> Bool {
        switch tag {
        case 0:
            
            guard (openedFile?.count ?? 0) > 0 else {
                dialogError(question: "Error!", text: "Please, open a file first.")
                return false
            }
            hashStr = SHA1.hexString(from: openedFile!) ?? ""
            guard hashStr != "" else {
                dialogError(question: "Error!", text: "Hash?")
                return false
            }
            
            guard (Int(qField.stringValue) != nil) && (Int(qField.stringValue)!.isPrime) else {
                dialogError(question: "Error!", text: "q is invalid number.")
                return false
            }
            q = Int(qField.stringValue)!
            
            guard (Int(pField.stringValue) != nil) && (Int(pField.stringValue)!.isPrime) && ((Int(pField.stringValue)!-1)%q == 0) else {
                dialogError(question: "Error!", text: "p is invalid number.")
                return false
            }
            p = Int(pField.stringValue)!
            
            guard (Int(hField.stringValue) != nil) && (Int(hField.stringValue)! >= 1) && (Int(hField.stringValue)! <= (p-1)) else {
                dialogError(question: "Error!", text: "h is invalid number.")
                return false
            }
            h = Int(hField.stringValue)!
            
            g = fastexp(a: h, z: (p-1)/q, n: p)
            guard g > 1 else {
                dialogError(question: "Error!", text: "g <= 1.")
                return false
            }
            gField.stringValue = String(g)
            
            guard (Int(xField.stringValue) != nil) && (Int(xField.stringValue)! >= 0) && (Int(xField.stringValue)! <= q) else {
                dialogError(question: "Error!", text: "x is invalid number.")
                return false
            }
            x = Int(xField.stringValue)!
            
            y = fastexp(a: g, z: x, n: p)
            yField.stringValue = String(y)
            
            guard (Int(kField.stringValue) != nil) && (Int(kField.stringValue)! >= 0) && (Int(kField.stringValue)! <= q) else {
                dialogError(question: "Error!", text: "k is invalid number.")
                return false
            }
            k = Int(kField.stringValue)!
            
            r = fastexp(a: g, z: k, n: p) % q
            s = fastexp(a: k, z: q-2, n: q) * mod(stringHash: hashStr, plus: x*r, divisedBy: q)
            
            guard (r != 0) && (s != 0) else {
                dialogError(question: "Error!", text: "Enter other k!")
                return false
            }
    
        case 1:
            
            guard (openedFile?.count ?? 0) > 0 else {
                dialogError(question: "Error!", text: "Please, open a file.")
                return false
            }
            hashStr = SHA1.hexString(from: openedFile!) ?? ""
            guard hashStr != "" else {
                dialogError(question: "Error!", text: "Hash?")
                return false
            }
            guard openedSignature != nil else {
                dialogError(question: "Error!", text: "Please, open a signature.")
                return false
            }
            r = openedSignature!.0
            s = openedSignature!.1
            
            guard (Int(qField.stringValue) != nil) && (Int(qField.stringValue)!.isPrime) else {
                dialogError(question: "Error!", text: "q is invalid number.")
                return false
            }
            q = Int(qField.stringValue)!
            
            guard (Int(pField.stringValue) != nil) && (Int(pField.stringValue)!.isPrime) && ((Int(pField.stringValue)!-1)%q == 0) else {
                dialogError(question: "Error!", text: "p is invalid number.")
                return false
            }
            p = Int(pField.stringValue)!
            
            g = fastexp(a: h, z: (p-1)/q, n: p)
            guard g > 1 else {
                dialogError(question: "Error!", text: "g <= 1.")
                return false
            }
            gField.stringValue = String(g)
            
            w = fastexp(a: s, z: q-2, n: q)
            u1 = mod(stringHash: hashStr, multiply: w, divisedBy: q)
            u2 = (r * w) % q
            v = (((g ^^ u1) * (y ^^ u2)) % p) % q
            
        default:
            return false
        }
        
        return true
    }
    
    @IBAction func openAction(_ sender: Any) {
        
    }
    
    @IBAction func createAction(_ sender: Any) {
        
    }
    
    @IBAction func openSignature(_ sender: Any) {
    }
    
    @IBAction func checkAction(_ sender: Any) {
        
    }
    
}
