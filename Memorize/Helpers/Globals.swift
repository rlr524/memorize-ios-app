//
//  Globals.swift
//  Memorize
//
//  Created by Robert Ranf on 7/14/22.
//

import SwiftUI

class K {
    static let gameType: String = "halloween" // "halloween", "holiday", "flag"
    static let numberOfPairsOfCards: Int = 13
    static let cornerRadius: CGFloat = 10
    static let lineWidth: CGFloat = 3
    static let fontScale: CGFloat = 0.7
    static let fontSize: CGFloat = 32.0
    static let timerCircleOpacity: CGFloat = 0.5
    static let timerCirclePadding: CGFloat = 5.0
    static let cardColor = Color.red
    static let aspectRatio: CGFloat = 2/3
    static let dealDuration: Double = 0.5
    static let totalDealDuration: Double = 2
    static let undealtHeight: CGFloat = 100
    static let undealtWidth = undealtHeight * aspectRatio
}
