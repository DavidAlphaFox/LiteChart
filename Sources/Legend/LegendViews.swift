//
//  LegendViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class LegendViews: UIView {
    
    private let configure: LegendViewsConfigure
    private var legendViews: [LegendView] = []
    
    init(configure: LegendViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertLegendViews()
        
        updateLegendViewsStaticConstraint()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LegendViewsConfigure.emptyConfigure
        super.init(coder: coder)
        insertLegendViews()
        
        updateLegendViewsStaticConstraint()
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        self.updateLegendViewsDynamicConstraint()
    }
    
    private func insertLegendViews() {
        for configure in self.configure.models {
            let legendView = LegendView(configure: configure)
            self.addSubview(legendView)
            self.legendViews.append(legendView)
        }
    }
    
    private func updateLegendViewsStaticConstraint() {
        for lengendView in self.legendViews {
            lengendView.snp.remakeConstraints{
                make in
                make.centerY.equalTo(0)
                make.trailing.equalToSuperview()
                make.height.equalTo(0)
                make.leading.equalToSuperview()
            }
        }
    }
    
    private func updateLegendViewsDynamicConstraint() {
        guard !self.legendViews.isEmpty else {
            return
        }
        
        var itemHeight = self.bounds.height / CGFloat(self.legendViews.count + 1)
        itemHeight = min(itemHeight, self.bounds.width / 4)
        let spaceHeight = itemHeight / 10
        let legendHeight = itemHeight - spaceHeight
        let fatherRect = self.bounds
        
        for (index, lengendView) in self.legendViews.enumerated() {
            let originalY = fatherRect.origin.y + CGFloat(index) * itemHeight
            let centerY = originalY + legendHeight / 2
            lengendView.snp.updateConstraints{
                make in
                make.centerY.equalTo(centerY)
                make.height.equalTo(legendHeight)
            }
        }
    }
}
