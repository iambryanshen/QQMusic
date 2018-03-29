//
//  QQDetailVM.swift
//  QQMusic
//
//  Created by brian on 2018/3/29.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

/*
 负责当前类的业务逻辑处理：上一首、下一首……等等
 */

import UIKit

class QQDetailVM: NSObject {
    
    /// 外界获取当前类的单例对象
    static let share = QQDetailVM()
    
    func playMusic(musicModel: MusicModel) {
    
        SFMusicTool.share.playMusic(musicName: musicModel.filename)
    }
}
