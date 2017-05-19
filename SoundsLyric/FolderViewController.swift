//
//  FolderViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/04/29.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift

/*
 継承は全てBaseViewControllerですかね
 class FolderViewController: BaseViewController {
 */
class FolderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Realmをインスタンス化
    // BaseViewControllerで書いているので下記はいらないですね
    let realm = try! Realm()    

    /// DB内のフォルダが格納されるリスト。
    var folderArray = try! Realm().objects(Folder.self).sorted(byKeyPath: "title", ascending: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addFolder(_ sender: Any) {
        print("フォルダー追加ボタンが押されました")
        
        // 以下Alertの設定
        // TextFieldを追加
        Const.alertAddFolder.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "名前"
            textField.returnKeyType = .done
        })
        
        // OKアクションを生成
        let defaultAction = UIAlertAction(title: "保存", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            print("保存ボタンが押されました")
            /// テキストが入力されていれば表示
            if let textFields = Const.alertAddFolder.textFields as Array<UITextField>? {
                for textField in textFields {
                    
                    let folder = Folder()
                    
                    if self.folderArray.count != 0 {
                        folder.id = self.folderArray.max(ofProperty: "id")! + 1
                    }
                    
                    try! self.realm.write {
                        folder.title = textField.text!
                        self.realm.add(folder, update: true)
                    }
                    // TableViewを再読み込み.
                    self.tableView.reloadData()
   
                }
            }
        })
        Const.alertAddFolder.addAction(defaultAction)
        
        // Cancelアクションを生成
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        Const.alertAddFolder.addAction(cancelAction)
        
        // シミュレータの種類によっては、これがないと警告が発生
        Const.alertAddFolder.view.setNeedsLayout()
        
        // アラートを画面に表示
        self.present(Const.alertAddFolder, animated: true, completion: nil)
        
        // TableViewを再読み込み.
        tableView.reloadData()
    }
    
    @IBAction func editFolder(_ sender: UIBarButtonItem) {
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
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - UITableViewDataSource
extension FolderViewController: UITableViewDataSource {
        
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderArray.count
    }
    
    /// 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderTableViewCell", for: indexPath)
        
        // CellにTitleを表示
        let folder = folderArray[indexPath.row]
        cell.textLabel?.text = folder.title
        
        return cell
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.folderArray[indexPath.row])
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension FolderViewController: UITableViewDelegate {
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // SongListVCに遷移する
        let songListVC = self.storyboard?.instantiateViewController(withIdentifier: "SongListVC") as! SongListViewController
        self.navigationController?.pushViewController(songListVC, animated: true)
        songListVC.songArray = folderArray[indexPath.row].songs
        
        // セルの選択を解除する
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    // セルの並び替えを有効にする
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}
