//
//  SongListViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/04/29.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift

class SongListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Realmをインスタンス化
    let realm = try! Realm()
    let folder = Folder()
    
    // DB内の曲が格納されるリスト。日付の降順でソート。以降、内容をアップデートするとリスト内は自動的に更新される
    var songArray = try! Realm().objects(Song.self).sorted(byKeyPath: "date", ascending: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavBarのタイトルにフォルダ名を反映
        navigationItem.title = folder.title

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let songEditVC = segue.destination as! SongEditViewController
        
        if segue.identifier == "ComposeSong" {
            // 曲を新規作成する場合の遷移
            let song = Song()
            song.date = NSDate()
            
            if songArray.count != 0 {
                song.id = songArray.max(ofProperty: "id")! + 1
            }
            
            songEditVC.song = song
            
        } else if segue.identifier == "showEditSong" {
            // セルをタップして既存の曲を編集する場合の遷移
            let indexpath = self.tableView.indexPathForSelectedRow
            songEditVC.song = songArray[indexpath!.row]
        }
    }


    /// 画面が表示される直前に呼び出されるメソッド
    ///
    /// - Parameter animated: animated
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TableViewを更新する
        tableView.reloadData()
    }
    
    @IBAction func editSong(_ sender: UIBarButtonItem) {
        if isEditing {
            print("（セル編集の）完了ボタンが押されました")
            super.setEditing(false, animated: true)
            tableView.setEditing(false, animated: true)
            sender.title = "編集"
        } else {
            print("セル編集ボタンが押されました")
            super.setEditing(true, animated: true)
            tableView.setEditing(true, animated: true)
            sender.title = "完了"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - UITableViewDataSource
extension SongListViewController: UITableViewDataSource {
    
    // データの数（＝セルの数）を返す（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songArray.count
    }
    
    // 各セルの内容を返すメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongListViewCell", for: indexPath as IndexPath)
        
        // CellにTitleを表示
        let song = songArray[indexPath.row]
        cell.textLabel?.text = song.title
        // 日時をフォーマットし、Cellに表示
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        let dateString = formatter.string(from: song.date as Date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.songArray[indexPath.row])
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
}
    
// MARK: - UITableViewDelegate
extension SongListViewController: UITableViewDelegate {
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditSong", sender: nil)
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
}
