//
//  PlayingViewController.swift
//  QQMusic
//
//  Created by brian on 2018/3/28.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit
import AVFoundation

class PlayingViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    lazy var musics: [MusicModel] = [MusicModel]()
    
    var progressTimer: Timer?
    weak var player: AVAudioPlayer?
    
    /// 当前播放的音乐
    var currentMusic: MusicModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBlurView()
        setProgressSlider()
        setIconImageView()
        
        // 加载数据
        loadMusicData()
        
        // 第一次进入播放歌曲
        currentMusic = musics[0]
        startPlayMusic()
        
        // 添加定时器
        addProgressTimer()
        
        // 给icon添加旋转动画
        addIconAnimation()
    }
}

//MARK: - 改变进度，监听Slider的点击和拖动
extension PlayingViewController {
    
    // 按下slider时移除定时器
    @IBAction func sliderTouchDown(_ sender: UISlider) {
        removeProgressTimer()
    }
    
    // 松开slider时改变歌曲进度
    @IBAction func sliderTouchUp(_ sender: UISlider) {
        let currentTime: TimeInterval = TimeInterval(progressSlider.value) * (player?.duration ?? 0)
        player?.currentTime = currentTime
        addProgressTimer()
    }
    
    // 滑动slider时改变当前时间（currentTimeLabel）的值
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentTime: TimeInterval = TimeInterval(progressSlider.value) * (player?.duration ?? 0)
        currentTimeLabel.text = stringWithTime(time: currentTime)
    }
    
    @IBAction func sliderTapGesture(_ sender: UITapGestureRecognizer) {
        // 获取用户点击在progressSlider上的位置
        let point = sender.location(in: progressSlider)
        // 计算点击的位置相当于整个进度条的比例
        let radio = point.x / progressSlider.bounds.width
        // 计算点击位置对应的歌曲时间
        let currentTime = (player?.duration ?? 0) * TimeInterval(radio)
        // 播放点击位置对应歌曲进度
        player?.currentTime = currentTime        
        // 立即修改歌曲进度
        updateMusicInfo()
    }
}

//MARK: - 播放器控制
extension PlayingViewController {
    
    /// 暂停和开始播放
    ///
    /// - Parameter sender: 暂停/开始播放按钮
    @IBAction func playOrPause(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            // 暂停播放
            player?.pause()
            // 移除定时器
            removeProgressTimer()
            // 移除icon layer动画
            iconImageView.layer.pauseAnimation()
        } else {
            // 开始播放
            player?.play()
            // 添加定时器
            addProgressTimer()
            // 添加icon layer动画
            iconImageView.layer.startAnimation()
        }
    }
    
    /// 上一首
    ///
    /// - Parameter sender: 上一首按钮
    @IBAction func nextMusic() {
        
        guard let currentIndex = musics.index(of: currentMusic) else {
            return
        }
        var nextIndex = currentIndex + 1
        if nextIndex > musics.count - 1 {
            nextIndex = 0
        }
        currentMusic = musics[nextIndex]
        startPlayMusic()
    }
    
    
    /// 下一首
    ///
    /// - Parameter sender: 下一首按钮
    @IBAction func previousMusic(_ sender: UIButton) {
        guard let currentIndex = musics.index(of: currentMusic) else {
            return
        }
        var previousIndex = currentIndex - 1
        if previousIndex < 0 {
            previousIndex = musics.count - 1
        }
        currentMusic = musics[previousIndex]
        
        startPlayMusic()
    }
}

//MARK: - 设置UI界面的内容
extension PlayingViewController {
    
    func setBlurView() {
        
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = bgImageView.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgImageView.addSubview(effectView)
    }
    
    func setProgressSlider() {
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: UIControlState.normal)
    }
    
    func setIconImageView() {
        iconImageView.layer.cornerRadius = iconImageView.bounds.width * 0.5
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderColor = UIColor.black.cgColor
        iconImageView.layer.borderWidth = 8
    }
}

//MARK: - 加载数据
extension PlayingViewController {
    
    func loadMusicData() {
        
        guard let urlPath = Bundle.main.url(forResource: "Musics", withExtension: "plist") else {
            return
        }
        
        let musicArray = NSArray(contentsOf: urlPath) as! [[String: String]]
        
        for music in musicArray {
            musics.append(MusicModel(dict: music))
        }
    }
}

//MARK: - 播放歌曲
extension PlayingViewController {
    
    func startPlayMusic() {
        
        // 播放歌曲
        guard let player = SFMusicTool.playMusic(musicName: currentMusic.filename) else {
            return
        }
        self.player = player
        self.player?.delegate = self
        
        // 设置歌曲的内容
        songLabel.text = currentMusic.name
        singerLabel.text = currentMusic.singer
        
        bgImageView.image = UIImage(named: currentMusic.icon)
        iconImageView.image = UIImage(named: currentMusic.icon)
        
        currentTimeLabel.text = stringWithTime(time: player.currentTime)
        totalTimeLabel.text = stringWithTime(time: player.duration)
    }
    
    
    /// 添加iCON的旋转动画
    func addIconAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Float.pi * 2
        animation.repeatCount = Float.infinity
        animation.duration = 30
        iconImageView.layer.add(animation, forKey: nil)
    }
    
    
    /// 根据秒数计算得到格式为：“00:00”的字符串
    ///
    /// - Parameter time: 时间：秒数
    /// - Returns: 格式为：“00:00”的字符串
    func stringWithTime(time: TimeInterval) -> String {
        let minute = Int(time)/60
        let second = Int(time)%60
        return String(format: "%02d:%02d", arguments: [minute, second])
    }
}

//MARK: - 添加定时器，更新播放过程中的歌曲信息
extension PlayingViewController {
    
    func addProgressTimer() {
        progressTimer = Timer(fireAt: Date(), interval: 1.0, target: self, selector: #selector(updateMusicInfo), userInfo: nil, repeats: true)
        RunLoop.current.add(progressTimer!, forMode: RunLoopMode.commonModes)
        
    }
    
    func removeProgressTimer() {
        // 删除RunLoop中的定时器
        progressTimer?.invalidate()
        // 删除当前类对定时器的强引用
        progressTimer = nil
    }
    
    @objc
    func updateMusicInfo() {
        
        guard let currentTime = player?.currentTime else {
            return
        }
        
        currentTimeLabel.text = stringWithTime(time: currentTime)
        progressSlider.value = Float(currentTime) / Float(player!.duration)
    }
}

//MARK: - AVAudioPlayerDelegate
extension PlayingViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextMusic()
    }
}
