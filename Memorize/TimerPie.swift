//
//  TimerPie.swift
//  Memorize
//
//  Created by Rob Ranf on 6/27/22.
//

import SwiftUI

struct TimerPie: Shape {
    // Var because they are being animated
    var startAngle: Angle
    var endAngle: Angle
    // Var because will be used in a user configuration
    var clockwise: Bool = false
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        p.addLine(to: center)
        return p
    }
}
