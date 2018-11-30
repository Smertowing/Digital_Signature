//
//  CommonFunctions.swift
//  Digital_Signature
//
//  Created by Kiryl Holubeu on 11/24/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Foundation

func findSandT(_ num: BInt) -> (BInt, BInt){
    var n: BInt = 0
    var number: BInt = num - 1
    while number % 2 == 0 {
        n += 1
        number /= 2
    }
    return (n,number)
}

extension BInt {
  //  var isPrime: Bool {
  //      return self > 1 && !(2 ..< self).contains { self % $0 == 0 }
  //  }
    var isPrime: Bool {
        
        if (self == 1) || (self == 2) {
            return true
        }
        if (self == 0) || (self % 2 == 0) {
            return false
        }
        
        return true
    }
}

// test Ferma for prime numbers
func ferma(_ x: BInt) -> Bool {
    if (x == 1) { return false}
    if (x == 2) || (x == 1) { return true }
    for _ in 0..<20 {
        let a = random(from: 2, to: x-1)
        let kek = gcd(a, x)
        if kek != 1 {
            return false
        }
        if fastexp(a, x-1, x) != 1 {
            return false
        }
    }
    return true
}

// Fast exponentiation algorithm
func fastexp(_ a: BInt,_ z: BInt,_ n: BInt) -> BInt {
    var a1: BInt = a, z1 = z
    var x: BInt = 1
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

func gcd(_ a: BInt, _ b: BInt) -> BInt {
    if b==0 {
        return a
    } else {
        return gcd(b, a%b)
    }
}

func random(from x: BInt, to y: BInt) -> BInt {
    return (BInt(Int.random(in: 0...Int.max)) * 555) % (y-x) + x
}

