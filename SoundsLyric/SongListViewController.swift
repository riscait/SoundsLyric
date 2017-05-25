//
//  SongListViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/04/29.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift

class SongListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var songCountLabel: UILabel!
    
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

    var songOwner: Folder!
    
    var songArray: List<Song>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// セグエで画面遷移するときのメソッド
    ///
    /// - Parameters:
    ///   - segue: ストーリーボードで設定したセグエ
    ///   - sender: Any?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let songEditVC = segue.destination as! SongEditViewController
        
        if segue.identifier == "ComposeSong" {
            // 曲を新規作成する場合の遷移
            
            let song = Song()
            // 配列0件の場合(nil)に前の画面から受け取っているownerを使用
            let owner = songArray.first?.owner ?? songOwner
            song.owner = owner
            
            // 今ある最大のidに１を足した数をidに設定
            // 厳密に言うとFolder結びつきではなく「全てのsong」に対してのPrimaryなので
            var lastId = self.newId(model: song)!
            song.id = lastId
            
            song.date = NSDate() // 現在時刻を登録
            
            let lyricA = Lyric()
            // AでユニークIDを発行し、以降1ずつインクリメント
            lastId = self.newId(model: lyricA)!
            
            lyricA.owner = song
            lyricA.id = lastId
            lyricA.name = "Aメロ"
            lyricA.text = "これは曲追加時にデフォルトで設定するAメロの歌詞です"
            
            let lyricB = Lyric()
            lyricB.owner = song
            lyricB.id = lastId + 1
            lyricB.name = "Bメロ"
            lyricB.text = "これは曲追加時にデフォルトで設定するBメロの歌詞です"
            
            let lyricC = Lyric()
            lyricC.owner = song
            lyricC.id = lastId + 2
            lyricC.name = "Cメロ"
            lyricC.text = "これは曲追加時にデフォルトで設定するCメロの歌詞です"
            
            // リレーション挿入
            song.lyrics.append(lyricA)
            song.lyrics.append(lyricB)
            song.lyrics.append(lyricC)
            

            // Realmに保存
            try! realm.write {
                // 最後に配列へ追加
                songArray.append(song)
                
                // 新規作成
                realm.add(song, update: true)
                realm.add(lyricA, update: true)
                realm.add(lyricB, update: true)
                realm.add(lyricC, update: true)
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
        print("labelを更新")
        updateLabel()
    }
    
    func updateLabel() {
        songCountLabel.text = "\(songArray.count)曲"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - UITableViewDataSource
extension SongListViewController: UITableViewDataSource {
    
    // データの数（＝セルの数）を返す（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("現在、\(songArray.count)曲あります")
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
            print("labelを更新")
            updateLabel()
        }
    }
}
    
// MARK: - UITableViewDelegate
extension SongListViewController: UITableViewDelegate {
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEditSong", sender: nil)
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
}
