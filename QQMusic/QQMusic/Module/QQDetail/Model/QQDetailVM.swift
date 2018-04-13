//
//  QQDetailVM.swift
//  QQMusic
//
//  Created by brian on 2018/4/2.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

/*
 负责当前类的业务逻辑处理：上一首、下一首……等等
 */

import UIKit
import MediaPlayer

class QQDetailVM: NSObject {
    
    /// 外界获取当前类的单例对象
    static let share = QQDetailVM()
    
    /// 音乐列表
    var musics: [MusicModel]?
    
    /// 记录当前播放的音乐
    var currentIndex: Int = 0 {
        didSet {
            guard let musics = musics else {return}
            /*
             切换音乐时的临界值判断
             > 保证列表最后一个数据的下一个是列表的第一个数据
             > 列表的第一个数据的上一个是列表的最后一个数据
             为什么写在这里？
             > 因为当currentIndex发生变化时会执行didSet
             > 在这里判断，符合谁的事情谁处理的原则！！！
             */
            if currentIndex > musics.count - 1 {
                currentIndex = 0
            } else if currentIndex < 0 {
                currentIndex = musics.count - 1
            }
        }
    }
    
    /// 当前正在播放的歌曲信息的模型
    private var musicCurrentModel: QQMusicCurrentModel = QQMusicCurrentModel()
    
    /// 获取当前正在播放的歌曲信息
    ///
    /// - Returns: 当前正在播放的歌曲信息
    func getCurrentMusicModel() -> QQMusicCurrentModel {
        if let musics = musics {
            musicCurrentModel.musicModel = musics[currentIndex]
        }
        musicCurrentModel.currentTime = SFMusicTool.share.player?.currentTime ?? 0
        musicCurrentModel.totalTime = SFMusicTool.share.player?.duration ?? 0
        musicCurrentModel.isPlaying = SFMusicTool.share.player?.isPlaying ?? false
        musicCurrentModel.currentTime = SFMusicTool.share.player?.currentTime ?? 0
        return musicCurrentModel
    }
    
    /// 根据所有的歌词数据和当前播放的时间获取当前歌词对应的行数
    ///
    /// - Parameters:
    ///   - lyricModelArray: 所有的歌词模型数据
    ///   - currentTime: 音乐当前播放的时间
    ///   - completion: 找到歌词对应行的回调
    func getCurrentLyricRow(lyricModelArray: [LyricModel], currentTime: TimeInterval, completion: (Int, LyricModel) -> Void) {
        for index in 0..<lyricModelArray.count {
            if lyricModelArray[index].startTime < currentTime && lyricModelArray[index].endTime > currentTime {
                completion(index, lyricModelArray[index])
            }
        }
    }
}

extension QQDetailVM {
    
    /// 播放指定的歌曲
    ///
    /// - Parameter musicModel: 歌曲的数据模型
    func playMusic(musicModel: MusicModel) {
        
        SFMusicTool.share.playMusic(musicName: musicModel.filename)
        
        // 如果有音乐列表，且音乐列表中保存了当前正在播放的音乐，就给记录当前播放音乐的index赋值
        if let currentIndex = musics?.index(of: musicModel) {
            self.currentIndex = currentIndex
        }
    }
    
    /// 继续播放当前歌曲
    func continuePlayMusic() {
        SFMusicTool.share.continuePlayMusic()
    }
    
    /// 暂停播放当前歌曲
    func pausePlayMusic() {
        SFMusicTool.share.pausePlayMusic()
    }
    
    /// 播放下一首歌曲
    func playNextMusic() {
        // 如果没有音乐列表不需要上下切换数据
        guard let musics = musics else {
            // 可以在这里实现弹框提示，没有下一首了……
            // ……
            return
        }
        // 因为在currentIndex的属性didSet方法中已经做了临界值判断，这里不需要再处理
        currentIndex += 1
        playMusic(musicModel: musics[currentIndex])
    }
    
    /// 播放上一首歌曲
    func playPreviousMusic() {
        guard let musics = musics else {
            return
        }
        currentIndex -= 1
        playMusic(musicModel: musics[currentIndex])
    }
    
    /// 设置锁屏信息
    func setupLockScreen() {
        
        // 1. 获取当前正在播放的音乐信息
        let currentMusicModel = getCurrentMusicModel()
        
        // 2. 获取锁屏信息中心
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        
        // 3. 创建并设置锁屏信息
        let artwork = MPMediaItemArtwork(boundsSize: CGSize.zero) { (size) -> UIImage in
            let imageName = currentMusicModel.musicModel?.singerIcon ?? ""
            let image = UIImage(named: imageName) ?? UIImage()
            return image
        }
        let nowPlayingInfo: [String: Any] = [MPMediaItemPropertyAlbumTitle: currentMusicModel.musicModel?.name as Any,
                                             MPMediaItemPropertyArtist:currentMusicModel.musicModel?.singer as Any,
                                             MPMediaItemPropertyPlaybackDuration:currentMusicModel.totalTime as Any,
                                             MPNowPlayingInfoPropertyElapsedPlaybackTime:currentMusicModel.currentTime as Any,
                                             MPMediaItemPropertyArtwork:artwork
                                             ]
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        
        // 4. 接收远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
}
