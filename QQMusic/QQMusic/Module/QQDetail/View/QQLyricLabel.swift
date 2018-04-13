//
//  QQLyricLabel.swift
//  QQMusic
//
//  Created by brian on 2018/4/13.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

class QQLyricLabel: UILabel {
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.green.set()
        UIRectFillUsingBlendMode(CGRect(x: 0, y: 0, width: rect.width * progress, height: rect.height), CGBlendMode.sourceIn)
        
        /*
        let rect = CGRect(x: 0, y: 0, width: rect.width * progress, height: rect.height)
        UIColor.green.set()
        UIRectFill(rect)
        */
    }
}
