//
//  QQListCell.swift
//  QQMusic
//
//  Created by brian on 2018/3/29.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

enum CellAnimationType {
    case scale
    case rotation
}

class QQListCell: UITableViewCell {
    
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    
    class func qqlistCell(tableView: UITableView) -> QQListCell {
        let musicID = "musicID"
        var cell = tableView.dequeueReusableCell(withIdentifier: musicID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("QQListCell", owner: nil, options: nil)?.first as! QQListCell
        }
        return cell as! QQListCell
    }
    
    var music: MusicModel? {
        didSet {
            guard let music = music else {
                return
            }
            
            iconIV.image = UIImage(named: music.icon)
            songNameLabel.text = music.name
            singerNameLabel.text = music.singer
        }
    }
    
    // 重写该方法什么也不做，可以实现取消选中动画效果
    override func setSelected(_ selected: Bool, animated: Bool) {}
    
    // 取消选中高亮动画效果
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        iconIV.layer.contents = iconIV.bounds.width * 0.5
        iconIV.layer.masksToBounds = true
        
        songNameLabel.textColor = UIColor.white
        singerNameLabel.textColor = UIColor.white
    }
    
    func animation(animationType: CellAnimationType) {
        switch animationType {
        case .rotation:
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.x")
            animation.values = [-(Float.pi/4), 0, (Float.pi/4), 0]
            animation.repeatCount = 1
            animation.duration = 0.5
            layer.add(animation, forKey: nil)
        case .scale:
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 0.5
            animation.toValue = 1.0
            animation.repeatCount = 1
            animation.duration = 0.5
            layer.add(animation, forKey: nil)
        }
    }
}
