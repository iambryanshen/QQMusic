//
//  QQListCell.swift
//  QQMusic
//
//  Created by brian on 2018/4/2.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

enum CellAnimationType {
    case scale
    case rotation
}

class QQListCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    
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
            
            iconImageView.image = UIImage(named: music.icon)
            songLabel.text = music.name
            singerLabel.text = music.singer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        iconImageView.layer.contents = iconImageView.bounds.width * 0.5
        iconImageView.layer.masksToBounds = true
        
        songLabel.textColor = UIColor.white
        singerLabel.textColor = UIColor.white
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

    // 重写该方法什么也不做，可以实现取消选中动画效果
    override func setSelected(_ selected: Bool, animated: Bool) {}
    
    // 取消选中高亮动画效果
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
}
