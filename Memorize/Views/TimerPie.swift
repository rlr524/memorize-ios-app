//
//  TimerPie.swift
//  Memorize
//
//  Created by Rob Ranf on 8/29/23.
//

import SwiftUI

struct TimerPie: Shape {
    // Var because they are being animated; they're going to vary as the
    // animation is applied. Shapes can be animated, unlike views. Clockwise
    // needs to be a var because if it was a let, it would be initialized to
    // false and couldn't be changed.
    var startAngle: Angle
    var endAngle: Angle
    // Var because it will be used in later configurations
    var clockwise: Bool = false
    
    func path(in rect: CGRect) -> Path {
        let center = GCPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius + CGFloat(cos(startAngle.radians)),
            y: center.y + radius + CGFloat(sin(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: !clockwise)
        p.addLine(to: center)
        return p
    }

}
