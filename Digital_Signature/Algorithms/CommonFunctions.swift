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
        /*
        let k = 100
        let FST = findSandT(self)
        let s = FST.0
        let t = FST.1
        cycleA: for _ in 0..<k {
            let a = random(from: 2, to: self-2)
            var x = fastexp(a, t, self)
            if (x == 1) || (x == self-1) { continue cycleA }
            for _ in 0..<s-1 {
                x = fastexp(x, 2, self)
                if x == 1 { return false }
                if x == self - 1 { continue cycleA }
            }
            return false
        } */
        return true
    }
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

func random(from x: BInt, to y: BInt) -> BInt {
    return (BInt(Int.random(in: Int.min...Int.max)) * 912049124921421) % (y-x) + x
}

func log(_ a: BInt, _ n: BInt) -> BInt {
    return 1000
}
