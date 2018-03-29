//
//  QQListTableViewController.swift
//  QQMusic
//
//  Created by brian on 2018/3/29.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

class QQListTableViewController: UITableViewController {
    
    var musics: [MusicModel] = [MusicModel]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        musics = MusicModel.loadMusicModel()
    }
}

//MARK: - 设置UI界面
extension QQListTableViewController {
    
    func setupUI() {
        
        navigationController?.isNavigationBarHidden = true
        
        tableView.rowHeight = 80
        
        let backgroundView = UIImageView(image: UIImage(named: "QQListBack"))
        tableView.backgroundView = backgroundView
        
        tableView.separatorStyle = .none
    }
}

// MARK: - Table view data source
extension QQListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return musics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QQListCell.qqlistCell(tableView: tableView)
        cell.music = musics[indexPath.row]
        cell.animation(animationType: CellAnimationType.scale)
        return cell
    }
}

//MARK: - Table view delegate
extension QQListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        QQDetailVM.share.playMusic(musicModel: musics[indexPath.row])
        self.performSegue(withIdentifier: "ListToDetail", sender: nil)
    }
}
