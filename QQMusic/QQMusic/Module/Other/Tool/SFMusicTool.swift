//
//  SFMusicTool.swift
//  QQMusic
//
//  Created by brian on 2018/4/2.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

/*
 负责一首歌曲的播放、暂停
 */

/*
 后台播放步骤
 1. 打开后台播放模式
    Capabilities -> Background Modes -> Audio...
 2. 获取音频会话
 3. 设置会话类别（后台播放模式：AVAudioSessionCategoryPlayback）
 4. 激活会话
 */

import UIKit
import AVFoundation

class SFMusicTool: NSObject {
    
    var player: AVAudioPlayer?
    
    static let share: SFMusicTool = SFMusicTool()
    
    override init() {
        super.init()
        // 1. 获取音频会话
        let session = AVAudioSession.sharedInstance()
        do {
            // 2. 设置会话类别
            try session.setCategory(AVAudioSessionCategoryPlayback)
            // 3. 激活会话
            try session.setActive(true)
        } catch {
            print(error)
        }
    }
}

extension SFMusicTool {
    
    /// 开始播放某个音乐
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
    
    /// 继续播放当前音乐
    func continuePlayMusic() {
        player?.play()
    }
    
    /// 暂停播放当前音乐
    func pausePlayMusic() {
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
