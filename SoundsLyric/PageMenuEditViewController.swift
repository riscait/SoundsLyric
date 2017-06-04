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
    

    /// セクションを追加するボタンのメソッド
    @IBAction func addSectionButton(_ sender: Any) {
        print("セクション追加ボタンが押されました！")
        // Alertを呼び出し
        let alert = AlertUtil.createAddedAlertController(createName: "新規セクション")
        // TextFieldを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "名前"
            textField.returnKeyType = .done
        })
        // OKアクションを生成
        let defaultAction = UIAlertAction(title: "保存", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            print("保存ボタンが押されました")
            /// テキストが入力されていれば表示
            if let textFields = alert.textFields as Array<UITextField>? {
                for textField in textFields {
                    
                    let lyric = Lyric()
                    
                    lyric.owner = self.song
                    lyric.id = self.newId(model: lyric)!
                    lyric.name = textField.text!
                    lyric.text = "testestes"
                    
                    // Realmに保存
                    try! self.realm .write {
                        // リレーション追加
                        self.lyrics.append(lyric)
                        self.realm.add(lyric, update: true)
                    }
                }
            }
        })
        alert.addAction(defaultAction)

        // Cancelアクションを生成
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // シミュレータの種類によっては、これがないと警告が発生
        alert.view.setNeedsLayout()
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
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
        print("現在、\(lyrics.count)個のセクションがあります")
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
        // メニュータイトル
        return IndicatorInfo(title: "Edit")
    }
}
