//
//  LyricModel.swift
//  QQMusic
//
//  Created by brian on 2018/4/12.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

class LyricModel: NSObject {

    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var currentTime: TimeInterval = 0
    var lyricContent: String = ""
}

extension LyricModel {
    
    class func loadMusicLyric(lyricName: String) -> [LyricModel] {
        
        guard let filePath = Bundle.main.path(forResource: lyricName, ofType: nil) else {
            return [LyricModel]()
        }
        
        // 获取歌词文件中的全部字符
        var lyricString: String = ""
        do {
            lyricString = try String(contentsOfFile: filePath)
        } catch {
            print(error)
        }

        let lyricArray = lyricString.components(separatedBy: "\n")
        
        var lyricModelArray: [LyricModel] = [LyricModel]()
        
        for lyric in lyricArray {
            
            // 过滤无效歌词
            if lyric.contains("[al:") || lyric.contains("[ar:") || lyric.contains("[al:") {
                continue
            }
            
            // 替换歌词中的中括号
            let lyric = lyric.replacingOccurrences(of: "[", with: "")
            let lyricArray = lyric.components(separatedBy: "]")
            
            if lyricArray.count == 2 {
                let lyricModel = LyricModel()
                lyricModel.startTime = FormatTimeTool.getTime(formatTime: lyricArray[0])
                lyricModel.lyricContent = lyricArray[1]
                lyricModelArray.append(lyricModel)
            }
        }
        
        // 因为一行歌词的endTime就等于下一行歌词的开始时间，设置endTime
        for index in 0..<lyricModelArray.count {
            
            if index == lyricModelArray.count - 1 {
                break
            }
            lyricModelArray[index].endTime = lyricModelArray[index + 1].startTime
        }

        return lyricModelArray
    }
}
