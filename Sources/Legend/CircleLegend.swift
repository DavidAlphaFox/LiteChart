//
//  CircleLegend.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class CircleLegend: UIView {
    
    var configure: LegendConfigure
    
    init(configure: LegendConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.configure = LegendConfigure()
        super.init(coder:coder)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setShouldAntialias(true)
        context?.setAllowsAntialiasing(true)
        let width = rect.width
        let height = rect.height
        let radius = min(width, height) / 2
        let centerX = rect.origin.x + rect.width / 2
        let centerY = rect.origin.y + radius + (rect.height - 2 * radius) / 2 
        let centerPoint = CGPoint(x: centerX, y: centerY)
        context?.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: 360, clockwise: false)
        context?.setFillColor(self.configure.color.color.cgColor)
        context?.drawPath(using: .fill)
    }
}
