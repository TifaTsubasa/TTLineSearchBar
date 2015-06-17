//
//  TTLineSearchBar.swift
//  TTLineSearchBar
//
//  Created by 谢许峰 on 15/6/14.
//  Copyright (c) 2015年 tifatsubasa. All rights reserved.
//

import UIKit

class TTLineSearchBar: UIView {
    
    var searchBtn = UIButton()
    
    var linker = CADisplayLink()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.redColor()

        searchBtn.setImage(UIImage(named: "album"), forState: UIControlState.Normal)
        self.addSubview(searchBtn)
        
        linker = CADisplayLink(target: self, selector: "click")
        linker.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        println(searchBtn.frame)
        var ctx = UIGraphicsGetCurrentContext()
        var lineWidth : CGFloat = 2
        CGContextSetLineWidth(ctx, lineWidth)
        
        CGContextAddArc(ctx, rect.height/2, rect.height/2, rect.height/2 - lineWidth, CGFloat(-M_PI_2), CGFloat(M_PI_2), 1)
        CGContextAddLineToPoint(ctx, rect.width - rect.height / 2, rect.height - lineWidth)
        CGContextAddArc(ctx, rect.width - rect.height/2, rect.height/2, rect.height/2 - lineWidth, CGFloat(M_PI_2), CGFloat(-M_PI_2), 1)
        CGContextAddLineToPoint(ctx, rect.height / 2, lineWidth)
        
        CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor)
        CGContextStrokePath(ctx)

    }

    override func layoutSubviews() {
        var btnWH : CGFloat = 20
        var btnXY = (self.bounds.size.height - btnWH) / 2
        searchBtn.frame = CGRectMake(btnXY, btnXY, btnWH, btnWH)
        searchBtn.layer.cornerRadius = self.bounds.size.height / 2
    }
    
    func click() {
        println("")
    }
}
