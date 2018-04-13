//
//  QQMusicCurrentModel.swift
//  QQMusic
//
//  Created by brian on 2018/4/12.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

class QQMusicCurrentModel: NSObject {
    
    var musicModel: MusicModel?
    var currentTime: TimeInterval = 0
    var totalTime: TimeInterval = 0
    var isPlaying: Bool = false
    
    var currentTimeFormat: String {
        get {
            return FormatTimeTool.getFormatTime(time: currentTime)
        }
    }
    
    var totalTimeFormat: String {
        get {
            return FormatTimeTool.getFormatTime(time: totalTime)
        }
    }
}
