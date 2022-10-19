//
//  Cardify.swift
//  Memorize
//
//  Created by Robert Ranf on 7/14/22.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    /*
     This function would be just whatever content is being passed into .cardify, meaning
     whatever it is that we're modifying. Remember that all .modifier() is doing is returning
     a View that displays *this*.
     */
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingGlobals.cornerRadius)
            if isFaceUp {
                //
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingGlobals.lineWidth)
                content
            } else {
                shape.fill()
            }
        }
    }
}
