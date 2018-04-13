//
//  QQLyricTableVC.swift
//  QQMusic
//
//  Created by brian on 2018/4/13.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

private let kLyricCellID = "kLyricCellID"

class QQLyricTableVC: UITableViewController {
    
    var lyricDataSource: [LyricModel] = [LyricModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var currentLyricRow: Int = -1 {
        didSet {
            if oldValue == currentLyricRow {return}
            let indexPath = IndexPath(row: currentLyricRow, section: 0)
            
            // 刷新可见行
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: UITableViewRowAnimation.automatic)
            
            // 刷新之后再滚动
            tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        }
    }
    
    /// 歌词进度
    var progress: CGFloat = 0 {
        didSet {
            // 获取正在显示的歌词的cell
            let indexPath = IndexPath(row: currentLyricRow, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? QQLyricTableViewCell
            // 设置正在显示歌词的cell的进度
            cell?.progress = progress
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: tableView.bounds.height * 0.5, left: 0, bottom: tableView.bounds.height * 0.5, right: 0)
    }
}

// MARK: - Table view data source
extension QQLyricTableVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lyricDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QQLyricTableViewCell.cellWithTableView(tableView: tableView)
        cell.lyricModel = lyricDataSource[indexPath.row]
        if currentLyricRow == indexPath.row {
            cell.progress = progress
        } else {
            cell.progress = 0
        }
        return cell
    }
}
