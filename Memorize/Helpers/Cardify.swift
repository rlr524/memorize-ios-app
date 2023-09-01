//
//  Cardify.swift
//  Memorize
//
//  Created by Robert Ranf on 7/14/22.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var rotation: Double // in degrees
    
    /*
     This function would be just whatever content is being passed into .cardify, meaning
     whatever it is that we're modifying. Remember that all .modifier() is doing is returning
     a View that displays *this*.
     */
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: K.cornerRadius)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: K.lineWidth)
            } else {
                shape.fill()
            }
            content
                .opacity(isFaceUp ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(isFaceUp ? 0 : 180), axis: (0, 1, 0))
    }
}
