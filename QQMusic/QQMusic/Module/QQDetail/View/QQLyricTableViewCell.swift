//
//  QQLyricTableViewCell.swift
//  QQMusic
//
//  Created by brian on 2018/4/13.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

class QQLyricTableViewCell: UITableViewCell {

    @IBOutlet weak var lyricLabel: QQLyricLabel!
    
    var lyricModel: LyricModel? {
        didSet {
            lyricLabel.text = lyricModel?.lyricContent
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            lyricLabel.progress = progress
        }
    }
    
    class func cellWithTableView(tableView: UITableView) -> QQLyricTableViewCell {
        let cellID = "lyricCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? QQLyricTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("QQLyricTableViewCell", owner: nil, options: nil)?.first as? QQLyricTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.lyricLabel.textAlignment = .center
            cell?.lyricLabel.font = UIFont(name: "PingFang SC", size: 15)
            cell?.lyricLabel.textColor = UIColor.white
        }
        return cell!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}
}
