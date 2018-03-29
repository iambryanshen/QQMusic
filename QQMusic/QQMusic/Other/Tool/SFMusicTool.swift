//
//  SFMusicTool.swift
//  iOSTips
//
//  Created by brian on 2018/3/27.
//  Copyright © 2018年 brian. All rights reserved.
//

/*
 负责一首歌曲的播放、暂停
 */

import UIKit
import AVFoundation

class SFMusicTool: NSObject {
    
    var player: AVAudioPlayer?
    
    static let share: SFMusicTool = SFMusicTool()
    
}

extension SFMusicTool {
    
    /// 开始播放
    ///
    /// - Parameter musicName: 资源名称
    @discardableResult
    func playMusic(musicName: String) -> AVAudioPlayer? {
        
        // 资源路径URL
        guard let url = Bundle.main.url(forResource: musicName, withExtension: nil) else {
            return nil
        }
        
        // 如果即将播放的资源和当前正在播放的资源相同，就继续播放
        if let currentUrl = player?.url {
            if currentUrl == url {
                player?.play()
                return player
            }
        }
        
        guard let player = try? AVAudioPlayer(contentsOf: url) else {
            return nil
        }
        self.player = player
        
        player.play()
        
        return  player
    }
    
    /// 暂停播放
    func pauseMusci() {
        player?.pause()
    }
    
    /// 停止播放，同时设置进度到0
    func stopMusic() {
        player?.currentTime = 0
        player?.stop()
    }
    
    /// 快进到指定时间
    ///
    /// - Parameter currentTime: 指定时间
    func setCurrentTime(currentTime: TimeInterval) {
        player?.currentTime = currentTime
    }
}
