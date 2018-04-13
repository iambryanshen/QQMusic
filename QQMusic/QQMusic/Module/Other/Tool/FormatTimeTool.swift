//
//  FormatTimeTool.swift
//  QQMusic
//
//  Created by brian on 2018/4/12.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

class FormatTimeTool: NSObject {

    
    /// 根据秒数获取格式化的时间
    ///
    /// - Parameter time: 秒数
    /// - Returns: 格式化的时间
    class func getFormatTime(time: TimeInterval) -> String {
        let minute = Int(time)/60
        let second = Int(time)%60
        return String(format: "%02d:%02d", arguments: [minute, second])
    }
    
    
    /// 根据格式化时间
    ///
    /// - Parameter formatTime: 格式化的时间
    /// - Returns: 秒数
    class func getTime(formatTime: String) -> TimeInterval {
        
        let timeArray = formatTime.components(separatedBy: ":")
        let minute = Double(timeArray[0]) ?? 0
        let second = Double(timeArray[1]) ?? 0
        
        return minute * 60 + second
    }
}
