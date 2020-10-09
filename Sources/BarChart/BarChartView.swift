//
//  BarChartView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class BarChartView: UIView {
    let configure: BarChartViewConfigure
    
    var axisView: AxisView?
    var yUnitLabel: DisplayLabel?
    var xUnitLabel: DisplayLabel?
    var coupleTitleView: [DisplayLabel] = []
    var valueView: [DisplayLabel] = []
    var barViewCollection: BarViewCoupleCollection?
    
    init(configure: BarChartViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertUnitLabel()
        insertAxisView()
        insertBarViewCollection()
        insertValueTitleView()
        insertCoupleTitleView()
        
        updateAxisViewStaticConstraints()
        updateUnitLabelStaticConstraints()
        updateBarViewCoupleCollectionStaticContraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = BarChartViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertUnitLabel()
        insertAxisView()
        insertBarViewCollection()
        insertValueTitleView()
        insertCoupleTitleView()
        
        updateAxisViewStaticConstraints()
        updateUnitLabelStaticConstraints()
        updateBarViewCoupleCollectionStaticContraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAxisViewDynamicConstraints()
        updateUnitLabelDynamicConstraints()
        updateValueViewDynamicConstraints()
        updateCoupleTitleViewDynamicConstraints()
    }
    
    private func insertUnitLabel() {
        var unitLabel: DisplayLabel
        
        if self.configure.isShowValueUnitString {
            unitLabel = DisplayLabel(configure: self.configure.valueUnitStringConfigure)
            self.addSubview(unitLabel)
            switch self.configure.direction {
            case .leftToRight:
                self.xUnitLabel = unitLabel
            case .bottomToTop:
                self.yUnitLabel = unitLabel
            }
        }
        
        if self.configure.isShowCoupleUnitString {
            unitLabel = DisplayLabel(configure: self.configure.coupleUnitStringConfigure)
            self.addSubview(unitLabel)
            switch self.configure.direction {
            case .leftToRight:
                self.yUnitLabel = unitLabel
            case .bottomToTop:
                self.xUnitLabel = unitLabel
            }
        }
        
    }
    
    private func insertCoupleTitleView() {
        for coupleTitleConfigure in self.configure.coupleTitleConfigure {
            let titleView = DisplayLabel(configure: coupleTitleConfigure)
            self.addSubview(titleView)
            self.coupleTitleView.append(titleView)
        }
    }
    
    private func insertValueTitleView() {
        for valueTitleConfigure in self.configure.valueTitleConfigure {
            let valueView = DisplayLabel(configure: valueTitleConfigure)
            self.addSubview(valueView)
            self.valueView.append(valueView)
        }
    }
    
    private func insertAxisView() {
        let axisView = AxisView(configure: self.configure.axisConfigure)
        self.addSubview(axisView)
        self.axisView = axisView
    }
    
    private func insertBarViewCollection() {
        guard let axis = self.axisView else {
            return
        }
        
        let barViews = BarViewCoupleCollection(configure: self.configure.barViewCoupleCollectionConfigure)
        axis.addSubview(barViews)
        self.barViewCollection = barViews
    }
    
    private var leftUnitViewWidth: CGFloat {
        let leftSpace = self.bounds.width / 10
        return min(leftSpace, 20)
    }
    
    private var leftViewWidth: CGFloat {
        let leftSpace = self.bounds.width / 10
        return min(leftSpace, 20)
    }
    
    private var bottomUnitViewHeight: CGFloat {
        let bottomSpace = self.bounds.height / 10
        return min(bottomSpace, 20)
    }
    
    private var bottomViewHeight: CGFloat {
        let bottomSpace = self.bounds.height / 10
        return min(bottomSpace, 20)
    }
    
    private var labelViewHeightSpace: CGFloat {
        let space = self.bounds.height / 10
        return min(space, 4)
    }
    
    private var labelViewWidthSpace: CGFloat {
        let space = self.bounds.width / 10
        return min(space, 4)
    }
    
    private var leftSpace: CGFloat {
        var space: CGFloat = 0
        if self.yUnitLabel != nil {
            space += self.labelViewWidthSpace + self.leftUnitViewWidth
        }
        if !self.coupleTitleView.isEmpty && self.configure.direction == .leftToRight {
            space += self.labelViewWidthSpace + self.leftViewWidth
            return space
        }
        if !self.valueView.isEmpty && self.configure.direction == .bottomToTop {
            space += self.labelViewWidthSpace + self.leftViewWidth
            return space
        }
        return space
    }
    
    private var bottomSpace: CGFloat {
        var space: CGFloat = 0
        if self.xUnitLabel != nil {
            space += self.labelViewHeightSpace + self.bottomUnitViewHeight
        }
        if !self.coupleTitleView.isEmpty && self.configure.direction == .bottomToTop {
            space += self.labelViewHeightSpace + self.bottomViewHeight
            return space
        }
        if !self.valueView.isEmpty && self.configure.direction == .leftToRight {
            space += self.labelViewHeightSpace + self.bottomViewHeight
            return space
        }
        return space
    }
    
    private func updateUnitLabelStaticConstraints() {
        guard let axis = self.axisView else {
            return
        }
        
        if let unit = self.yUnitLabel {
            unit.snp.updateConstraints{
                make in
                make.leading.equalToSuperview()
                make.width.equalTo(self.leftUnitViewWidth)
                make.top.equalToSuperview()
                make.bottom.equalTo(axis.snp.bottom)
            }
        }
        
        if let xUnit = self.xUnitLabel {
            xUnit.snp.updateConstraints{
                make in
                make.leading.equalTo(axis.snp.leading)
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(self.bottomUnitViewHeight)
            }
        }
    }
    
    private func updateUnitLabelDynamicConstraints() {
        
        if let unit = self.yUnitLabel {
            unit.snp.updateConstraints{
                make in
                make.width.equalTo(self.leftUnitViewWidth)
            }
        }
        
        if let xUnit = self.xUnitLabel {
            xUnit.snp.updateConstraints{
                make in
                make.height.equalTo(self.bottomUnitViewHeight)
            }
        }
    }
    
    private func updateAxisViewStaticConstraints() {
        guard let axis = self.axisView else {
            return
        }
        axis.snp.updateConstraints{
            make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview().priority(.init(750))
            make.bottom.equalToSuperview()
        }
    }
    
    private func updateAxisViewDynamicConstraints() {
        guard let axis = self.axisView else {
            return
        }
        axis.snp.updateConstraints{
            make in
            make.leading.equalToSuperview().offset(self.leftSpace).priority(.init(750))
            make.bottom.equalToSuperview().offset(0 - self.bottomSpace)
        }
    }
    
    private func updateBarViewCoupleCollectionStaticContraints() {
        guard let collection = self.barViewCollection else {
            return
        }
        collection.snp.remakeConstraints{
            make in
            make.bottom.top.trailing.leading.equalToSuperview()
        }
    }
    
    private func updateValueViewDynamicConstraints() {
        guard let axis = self.axisView else {
            return
        }
        switch self.configure.direction {
        case .bottomToTop:
            guard self.configure.yDividingPoints.count == self.configure.valueTitleConfigure.count,  self.configure.valueTitleConfigure.count == self.valueView.count else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            for index in 0 ..< self.configure.valueTitleConfigure.count {
                let yPoint = self.configure.yDividingPoints[index]
                let pointY = axis.bounds.height * (1 - yPoint)
                let endPoint = CGPoint(x: self.bounds.origin.x + self.leftSpace, y: self.bounds.origin.y + pointY)
                let center = CGPoint(x: endPoint.x - self.labelViewWidthSpace - self.leftViewWidth / 2, y: endPoint.y)
                var labelHeight = axis.bounds.height / CGFloat(self.configure.valueTitleConfigure.count + 1)
                labelHeight = min(labelHeight, 20)
                let labelView = self.valueView[index]
                labelView.snp.updateConstraints{
                    make in
                    make.center.equalTo(center)
                    make.width.equalTo(self.leftViewWidth)
                    make.height.equalTo(labelHeight)
                }
            }
        case .leftToRight:
            guard self.configure.xDividingPoints.count == self.configure.valueTitleConfigure.count, self.configure.valueTitleConfigure.count == self.valueView.count else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            for index in 0 ..< self.configure.valueTitleConfigure.count {
                let xPoint = self.configure.xDividingPoints[index]
                let pointX = axis.bounds.width * xPoint
                let endPoint = CGPoint(x: self.bounds.origin.x + self.leftSpace + pointX, y: self.bounds.origin.y + axis.bounds.height)
                let center = CGPoint(x: endPoint.x, y: endPoint.y + self.labelViewHeightSpace + self.bottomViewHeight / 2)
                var labelWidth = axis.bounds.width / CGFloat(self.configure.valueTitleConfigure.count + 1)
                labelWidth = min(labelWidth, 20)
                let labelView = self.valueView[index]
                labelView.snp.updateConstraints{
                    make in
                    make.center.equalTo(center)
                    make.height.equalTo(self.bottomViewHeight)
                    make.width.equalTo(labelWidth)
                }
            }
        }
    }
    
    private func updateCoupleTitleViewDynamicConstraints() {
        guard let axis = self.axisView else {
            return
        }
        guard self.configure.barViewCoupleNumber > 0 else {
            return
        }
        
        switch self.configure.direction {
        case .bottomToTop:
            guard self.configure.coupleTitleConfigure.count == self.configure.barViewCoupleNumber else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            let labelWidth = axis.bounds.width / CGFloat(self.configure.barViewCoupleNumber)
            var labelSpace = labelWidth / 10
            labelSpace = min(labelSpace, 4)
            var frontView: DisplayLabel?
            for labelView in self.coupleTitleView {
                guard let front = frontView else {
                    labelView.snp.updateConstraints{
                        make in
                        make.leading.equalTo(axis.snp.leading).offset(labelSpace / 2)
                        make.top.equalTo(axis.snp.bottom).offset(self.labelViewHeightSpace)
                        make.height.equalTo(self.bottomViewHeight)
                        make.width.equalTo(labelWidth - labelSpace)
                    }
                    frontView = labelView
                    continue
                }
                labelView.snp.updateConstraints{
                    make in
                    make.leading.equalTo(front.snp.trailing).offset(labelSpace)
                    make.top.equalTo(axis.snp.bottom).offset(self.labelViewHeightSpace)
                    make.height.equalTo(self.bottomViewHeight)
                    make.width.equalTo(labelWidth - labelSpace)
                }
                frontView = labelView
            }
        case .leftToRight:
            guard self.configure.coupleTitleConfigure.count == self.configure.barViewCoupleNumber else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            let labelHeight = axis.bounds.height / CGFloat(self.configure.barViewCoupleNumber)
            var labelSpace = labelHeight / 10
            labelSpace = min(labelSpace, 4)
            var frontView: DisplayLabel?
            for labelView in self.coupleTitleView {
                guard let front = frontView else {
                    labelView.snp.updateConstraints{
                        make in
                        make.trailing.equalTo(axis.snp.leading).offset(0 - self.labelViewWidthSpace)
                        make.bottom.equalTo(axis.snp.bottom).offset(0 - labelSpace / 2)
                        make.height.equalTo(labelHeight - labelSpace)
                        make.width.equalTo(self.leftViewWidth)
                    }
                    frontView = labelView
                    continue
                }
                labelView.snp.updateConstraints{
                    make in
                    make.trailing.equalTo(axis.snp.leading).offset(0 - self.labelViewWidthSpace)
                    make.bottom.equalTo(front.snp.top).offset(0 - labelSpace)
                    make.height.equalTo(labelHeight - labelSpace)
                    make.width.equalTo(self.leftViewWidth)
                }
                frontView = labelView
            }
        }
    }
    
}
