//
//  QQDetailVC.swift
//  QQMusic
//
//  Created by brian on 2018/4/2.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

class QQDetailVC: UIViewController {
    
    //MARK: - 一首歌曲需要设置一次的属性
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    //MARK: - 一首歌曲需要多次设置的属性
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var lyricLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playOrPauseButton: UIButton!
    
    // 显示歌词的背景View
    @IBOutlet weak var lyricScrollView: UIScrollView!
    
    var timer: Timer?
    var displayLink: CADisplayLink?
    
    lazy var visualEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: effect)
        return visualEffectView
    }()
    
    lazy var lyricTableVC: QQLyricTableVC = {
        return QQLyricTableVC()
    }()
    
}

//MARK: - 系统回调
extension QQDetailVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加毛玻璃效果
        addVisualEffectView()
        // 添加歌词视图
        addLyricView()
        // 设置歌词背景视图
        setLyricScrollView()
        // 设置progressSlider
        setProgressSlider()
        
        // 设置界面数据
        setupOnce()
    }
    
    /*
     该方法在每次布局发生变化时调用，在该方法中拿到的控件的frame都是控件最终显示的frame
     
     通过在该方法中给需要设置frame的控件布局，保证布局时拿到控件frame是最终的frame
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 设置毛玻璃效果的frame
        setVisualEffectViewFrame()
        // 设置歌词背景视图LyricScrollView的contentSize
        setLyricScrollViewFrame()
        // 设置歌词视图的frame
        setLyricViewFrame()
        // 设置iconImageView，因为设置圆角需要通过iconImageView的bounds，故在当前方法设置
        setIconImageview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTimer()
        addDisplayLink()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeTimer()
        removeDisplayLink()
    }
}

//MARK: - 数据设置
extension QQDetailVC {
    
    func setupOnce() {
        let musicCurrentModel = QQDetailVM.share.getCurrentMusicModel()
        if let icon = musicCurrentModel.musicModel?.icon {
            bgImageView.image = UIImage(named: icon)
            iconImageView.image = UIImage(named: icon)
        }
        songLabel.text = musicCurrentModel.musicModel?.name
        singerLabel.text = musicCurrentModel.musicModel?.singer
        totalTimeLabel.text = musicCurrentModel.totalTimeFormat
        playOrPauseButton.isSelected = musicCurrentModel.isPlaying
        progressSlider.value = 0
        
        if musicCurrentModel.isPlaying {
            addAnimation()
        } else {
            pauseAnimation()
        }
        
        // 设置歌词
        guard let lyricName = musicCurrentModel.musicModel?.lrcname else {
            return
        }
        // 根据歌词名字，获取歌词模型数据
        lyricTableVC.lyricDataSource = LyricModel.loadMusicLyric(lyricName: lyricName)
    }
    
    @objc
    func setupTimes() {
        let musicCurrentModel = QQDetailVM.share.getCurrentMusicModel()
        currentTimeLabel.text = musicCurrentModel.currentTimeFormat
        lyricLabel.text = musicCurrentModel.musicModel?.lrcname
        progressSlider.value = Float(musicCurrentModel.currentTime/musicCurrentModel.totalTime)
    }
}

//MARK: - 定时器的添加与移除
extension QQDetailVC {
    
    func addTimer() {
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(setupTimes), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func addDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateLyricRow))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func removeDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
}

//MARK: - 实时更新当前显示的歌词
extension QQDetailVC {
    
    @objc
    func updateLyricRow() {
        let musicCurrentModel = QQDetailVM.share.getCurrentMusicModel()
        QQDetailVM.share.getCurrentLyricRow(lyricModelArray: lyricTableVC.lyricDataSource, currentTime: musicCurrentModel.currentTime) { (row, lyricModel) in
            // 歌词滚动到指定行
            self.lyricTableVC.currentLyricRow = row
            
            // 更新指定行颜色的进度
            let progressTime = musicCurrentModel.currentTime - lyricModel.startTime
            let totalTime = lyricModel.endTime - lyricModel.startTime
            self.lyricTableVC.progress = CGFloat(progressTime/totalTime)
        }
    }
}

//MARK: - 界面设置
extension QQDetailVC {
    
    func addVisualEffectView() {
        bgImageView.addSubview(visualEffectView)
    }
    
    func setVisualEffectViewFrame() {
        visualEffectView.frame = bgImageView.frame
    }
    
    func addLyricView() {
        lyricScrollView.addSubview(lyricTableVC.tableView)
    }
    
    func setLyricViewFrame() {
        lyricTableVC.tableView.frame = lyricScrollView.bounds
        lyricTableVC.tableView.frame.origin.x = lyricTableVC.tableView.bounds.width
    }
    
    func setLyricScrollView() {
        lyricScrollView.delegate = self
        lyricScrollView.showsHorizontalScrollIndicator = false
        lyricScrollView.isPagingEnabled = true
    }
    
    func setLyricScrollViewFrame() {
        lyricScrollView.contentSize = CGSize(width: lyricScrollView.bounds.width * 2, height: 0)
    }
    
    func setIconImageview() {
        iconImageView.layer.cornerRadius = iconImageView.bounds.width * 0.5
        iconImageView.layer.masksToBounds = true
    }
    
    func setProgressSlider() {
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: UIControlState.normal)
        progressSlider.minimumTrackTintColor = UIColor(red: 100/255.0, green: 190/255.0, blue: 130/250.0, alpha: 1.0)
    }
}

//MARK: - UIScrollViewDelegate
extension QQDetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = 1 - scrollView.contentOffset.x/scrollView.bounds.width
        iconImageView.alpha = alpha
        lyricLabel.alpha = alpha
        singerLabel.alpha = alpha
    }
}

//MARK: - 动画处理
extension QQDetailVC {
    
    func addAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.duration = 30
        animation.isRemovedOnCompletion = false
        iconImageView.layer.add(animation, forKey: nil)
    }
    
    func pauseAnimation() {
        iconImageView.layer.pauseAnimation()
    }
    
    func resumeAnimation() {
        iconImageView.layer.resumeAnimation()
    }
}

//MARK: - 业务逻辑
extension QQDetailVC {
    
    /// 播放暂停
    @IBAction func playOrPauseMusic(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            QQDetailVM.share.continuePlayMusic()
            resumeAnimation()
        } else {
            QQDetailVM.share.pausePlayMusic()
            pauseAnimation()
        }
    }
    /// 上一首
    @IBAction func previousMusic(_ sender: UIButton) {
        QQDetailVM.share.playPreviousMusic()
        setupOnce()
    }
    /// 下一首
    @IBAction func nextMusic(_ sender: UIButton) {
        QQDetailVM.share.playNextMusic()
        setupOnce()
    }
    /// 关闭
    @IBAction func close(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension QQDetailVC {
    // 锁屏控制播放，暂停，上一首，下一首
    override func remoteControlReceived(with event: UIEvent?) {
        switch event?.subtype {
        case .remoteControlPlay?:
            QQDetailVM.share.continuePlayMusic()
        case .remoteControlPause?:
            QQDetailVM.share.pausePlayMusic()
        case .remoteControlNextTrack?:
            QQDetailVM.share.playNextMusic()
        case .remoteControlPreviousTrack?:
            QQDetailVM.share.playPreviousMusic()
        default:
            break
        }
        
        setupOnce()
    }
    
    // 摇一摇下一首
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        QQDetailVM.share.playNextMusic()
        setupOnce()
    }
}
