//
//  LineViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct LineViewConfigure {
    let points: [CGPoint]
    let legendConfigure: LegendConfigure
    let lineStyle: LineStyle
    let lineColor: LiteChartDarkLightColor
    let labelConfigure: [DisplayLabelConfigure]
    let isShowLabel: Bool
}

extension LineViewConfigure {
    private init() {
        self.points = []
        self.legendConfigure = .emptyConfigure
        self.lineColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.lineStyle = .dottedPolyline
        self.labelConfigure = []
        self.isShowLabel = false
    }
    
    static let emptyConfigure = LineViewConfigure()
}
