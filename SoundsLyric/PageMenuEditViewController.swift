//
//  PageMenuEditViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/28.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

class PageMenuEditViewController: BaseViewController {

    var song: Song!
    var lyrics: List<Lyric>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // セルを編集可能状態にする
        super.setEditing(true, animated: true)
        tableView.setEditing(true, animated: true)
    }
    
    /// 画面が表示される直前に呼び出されるメソッド
    ///
    /// - Parameter animated: animated
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TableViewを更新する
        tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource
extension PageMenuEditViewController: UITableViewDataSource {
    
    // データの数（＝セルの数）を返す（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("現在、\(lyrics.count)個の歌詞展開があります")
        return lyrics.count
    }
    
    // 各セルの内容を返すメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageMenuCell", for: indexPath)
        
        // CellにTitleを表示
        let page = lyrics[indexPath.row]
        cell.textLabel?.text = page.name
        
        return cell
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.lyrics[indexPath.row])
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension PageMenuEditViewController: UITableViewDelegate {
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    // セルの並び替えを有効にする
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {}

}

// MARK: - IndicatorInfoProvider
extension PageMenuEditViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Edit")
    }
}
