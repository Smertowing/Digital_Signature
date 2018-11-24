//
//  CommonFunctions.swift
//  Digital_Signature
//
//  Created by Kiryl Holubeu on 11/24/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Foundation

extension Int {
    var isPrime: Bool { return self > 1 && !(2 ..< self).contains { self % $0 == 0 } }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

// Fast exponentiation algorithm
func fastexp(a: Int, z: Int, n: Int) -> Int {
    var a1 = a, z1 = z
    var x = 1
    while z1 != 0 {
        while z1 % 2 == 0 {
            z1 = z1 / 2
            a1 = (a1 * a1) % n
        }
        z1 = z1 - 1
        x = (x * a1) % n
    }
    return x
}

// Mod of big number
func mod(stringHash str: String, plus: Int, divisedBy d: Int) -> Int {
    return 4
}

func mod(stringHash str: String, multiply: Int, divisedBy d: Int) -> Int {
    return 4
}
