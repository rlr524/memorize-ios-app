//
//  Extensions.swift
//  Memorize
//
//  Created by Rob Ranf on 11/19/21.
//

import Foundation

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
