//
//  Cardify.swift
//  Memorize
//
//  Created by Robert Ranf on 7/14/22.
//

import SwiftUI

struct Cardify: Animatable, ViewModifier {
    var rotation: Double // in degrees
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    /**
     This function would be just whatever content is being passed into .cardify, meaning
     whatever it is that we're modifying. Remember that all .modifier() is doing is returning
     a View that displays *this*.
     */
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: K.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: K.lineWidth)
            } else {
                shape.fill()
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        /// The card flip animation is performed here
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
}
