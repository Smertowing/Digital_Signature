//
//  CommonFunctions.swift
//  Digital_Signature
//
//  Created by Kiryl Holubeu on 11/24/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Foundation

extension BInt {
  //  var isPrime: Bool {
  //      return self > 1 && !(2 ..< self).contains { self % $0 == 0 }
  //  }
    var isPrime: Bool {
        if (self == 1) || (self % 2 == 0) {
            return false
        }
        let s = log(self, 2)
        for _ in 1...s + 1 {
            let a = random(from: 1, to: self-1)
            if test(a, self) {
                return false
            }
        }
        return true
    }
}

func to_reversed_binary(_ num: BInt) -> [Int] {
    var n: BInt = num
    var r = [Int]()
    while n > 0 {
        if n % 2 == 0 {
            r.append(0)
        } else {
            r.append(1)
        }
        n /= 2
    }
    return r
}

func test(_ a: BInt, _ n: BInt) -> Bool {
    var b = to_reversed_binary(n - 1)
    var k: BInt = 1
    for i in 0...(b.count - 1) {
        let x = k
        k = (k * k) % n
        if (k == 1) && (x != 1) && (x != n - 1) {
            return true
        }
        if b[i] == 1 {
            k = (k * a) % n
        }
    }
    if k != 1 {
        return true
    } else {
        return false
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
