//
//  MusicModel.swift
//  QQMusic
//
//  Created by brian on 2018/3/28.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

class MusicModel: NSObject {
    
    /// 歌曲名称
    @objc var name: String = ""
    /// 歌曲对应的Mp3文件名称
    @objc var filename: String = ""
    /// 歌词文件的名称
    @objc var lrcname: String = ""
    /// 歌手名称
    @objc var singer: String = ""
    /// 歌手的头像
    @objc var singerIcon: String = ""
    /// 歌手大图
    @objc var icon: String = ""
    
    init(dict: [String: String]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

extension MusicModel {
    
    class func loadMusicModel() -> [MusicModel] {
        
        guard let urlPath = Bundle.main.url(forResource: "Musics", withExtension: "plist") else {
            return [MusicModel]()
        }
        
        let musicArray = NSArray(contentsOf: urlPath) as! [[String: String]]
        
        var musics: [MusicModel] = [MusicModel]()
        for music in musicArray {
            musics.append(MusicModel(dict: music))
        }
        
        return musics
    }
}
