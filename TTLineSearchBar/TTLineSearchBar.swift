//
//  TTLineSearchBar.swift
//  TTLineSearchBar
//
//  Created by 谢许峰 on 15/6/14.
//  Copyright (c) 2015年 tifatsubasa. All rights reserved.
//

import UIKit

/** 数据管理类*/
class LineDrawTime {
    let time : Double = 0.5
    var index : Int = 0
    var width : CGFloat = 0.0
    var height : CGFloat = 0
    
    var topFraps : Int {
        return Int(lineTime * 60)
    }
    var circleFraps : Int {
        get {
            return Int(circleLineTime * 60)
        }
    }
    var totalLength : CGFloat {
        get {
            return (width - height) * 2 + height * CGFloat(M_PI)
        }
    }
    var topLineLength : CGFloat {
        get {
            return width - height
        }
    }
    var circleLength : CGFloat {
        get {
            return height * CGFloat(M_PI)
        }
    }
    var bottomLineLength : CGFloat {
        get {
            return topLineLength
        }
    }
    var lineTime : Double {
        get {
            return time * Double((width - height) / totalLength)
        }
    }
    var circleLineTime : Double {
        get {
            return time * Double((height * CGFloat(M_PI)) / totalLength)
        }
    }
}

/** 线性搜索栏*/
class TTLineSearchBar: UIView, UITextFieldDelegate {
    
    lazy var searchBtn = UIButton()
    
    lazy var searchBar = UITextField()
    
    lazy var linker = CADisplayLink()
    
    lazy var drawTime = LineDrawTime()
    
    var time : Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()
        
        searchBtn.setImage(UIImage(named: "searchBar"), forState: UIControlState.Normal)
        searchBtn.addTarget(self, action: "click", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(searchBtn)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        
        // Drawing code
        var ctx = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor)
        
        var lineWidth : CGFloat = 1.5
        CGContextSetLineWidth(ctx, lineWidth)
        
        // 左半圆 : 从上到下
        var searchCircle : Double = 0
        if drawTime.index > (Int(drawTime.time * 60) - drawTime.circleFraps) {
            searchCircle = M_PI * Double(drawTime.index - (Int(drawTime.time * 60) - drawTime.circleFraps)) / Double(drawTime.circleFraps)
        }
        if searchCircle > M_PI {
            searchCircle = M_PI
        }
        CGContextAddArc(ctx, rect.height/2, rect.height/2, rect.height/2 - lineWidth, CGFloat(-M_PI_2), CGFloat(-M_PI_2 - M_PI * 2 + searchCircle), 1)
        CGContextStrokePath(ctx)

        // 上横线
        CGContextMoveToPoint(ctx, rect.height / 2, lineWidth)
        var topWidth : CGFloat = 0
        if drawTime.index < drawTime.topFraps {
            topWidth = drawTime.topLineLength / CGFloat(drawTime.topFraps) * CGFloat(drawTime.index)
        } else {
            topWidth = drawTime.topLineLength
        }

        CGContextAddLineToPoint(ctx, rect.height / 2 + topWidth, lineWidth)
        CGContextStrokePath(ctx)
        
        // 右半圆 : 从下到上
        var circleAngle : CGFloat = 0
        if (drawTime.index > drawTime.topFraps) && (drawTime.index < drawTime.topFraps + drawTime.circleFraps) {
            circleAngle = CGFloat(M_PI) * CGFloat(drawTime.index - drawTime.topFraps) / CGFloat(drawTime.circleFraps)
        } else if drawTime.index > drawTime.topFraps + drawTime.circleFraps {
            circleAngle = CGFloat(M_PI)
        }
        CGContextAddArc(ctx, rect.width - rect.height/2, rect.height/2, rect.height/2 - lineWidth, CGFloat(-M_PI_2), CGFloat(-M_PI_2) + circleAngle, 0)
        
        // 下横线
        var bottomWidth : CGFloat = drawTime.topLineLength - drawTime.topLineLength / CGFloat(drawTime.topFraps) * CGFloat(drawTime.index - drawTime.topFraps - drawTime.circleFraps)
        if bottomWidth < rect.height / 2 {
            bottomWidth = -rect.height / 2
        }
        
        if drawTime.index > drawTime.topFraps + drawTime.circleFraps {
            CGContextAddLineToPoint(ctx, rect.height + bottomWidth, rect.height - lineWidth)
        }
        
        if (drawTime.index >= Int(drawTime.time * 60 + 1)) {
            println(drawTime.index)
            println(drawTime.time * 60)
        }
        
        CGContextStrokePath(ctx)
    }

    override func layoutSubviews() {
        
        drawTime.width = self.bounds.size.width
        drawTime.height = self.bounds.size.height
        println(drawTime.topFraps, drawTime.circleFraps, drawTime.totalLength, drawTime.lineTime, drawTime.circleLineTime)
        
        var btnWH : CGFloat = 20
        var btnXY = (self.bounds.size.height - btnWH) / 2
        searchBtn.frame = CGRectMake(btnXY, btnXY, btnWH, btnWH)
        searchBtn.layer.cornerRadius = self.bounds.size.height / 2
    }
    
    func click() {
        // 防止重复点击
        if drawTime.index != 0 {
            return
        }
        
        linker = CADisplayLink(target: self, selector: "addSearchBarOption")
        linker.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func addSearchBarOption () {
        if drawTime.index > Int(drawTime.time * 60) {
            linker.invalidate()
            linker.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            
            // 添加搜索栏，并获得键盘响应
            searchBar.frame = CGRectMake(self.bounds.size.height, 2, self.bounds.size.width - 2 * self.bounds.size.height, self.bounds.size.height - 4)
            searchBar.textColor = UIColor.whiteColor()
            self.addSubview(searchBar)
            searchBar.delegate = self
            searchBar.becomeFirstResponder()
            
            // 防止越界
//            drawTime.index = Int(drawTime.time * 60)
        } else {
            drawTime.index++
            self.setNeedsDisplay()
        }
    }
    
    func removeSearchBarOption () {
        if drawTime.index <= 0 {
            linker.invalidate()
            linker.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            
            // 添加搜索栏，并获得键盘响应
            searchBar.resignFirstResponder()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.searchBar.alpha = 0
                }, completion: { (bool :  Bool) -> Void in
                self.searchBar.removeFromSuperview()
            })
            
            // 防止越界
            drawTime.index = 0
        } else {
            drawTime.index--
            self.setNeedsDisplay()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        linker = CADisplayLink(target: self, selector: "removeSearchBarOption")
        linker.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        return true
    }
}

