//
//  FolderViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/04/29.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    /*
     ここが要はrealmで保持しているものになりますかね->Lesson6でいうとtask
     */
    // セルを格納する配列
    // こちらのデフォルトで決まっているものはConst.swiftなど(Lesson8参照)の定数をまとめて宣言する場所に固めておいておくと管理しやすいですよ
    var folders = ["最初にあるセル"]
    
    /*
     この以下二つのプロパティは不要かと思われます。
     上記、foldersが配列として情報を持っているため、※1
     プロパティは増やすこと全然構いませんが、宣言して多方で呼ばれて書き換えられるということでメンテナンス性がぐっと落ちますので、
     コード書いて行くうちにここいらないやんと思うことがあれば消して行くことを推奨します。
    */
    // セル（フォルダ）をタップしてSongListVCに遷移する時に渡す
    // セルの番号 // これはどのような理由で保持していますか？
    var folderNumber: Int!
    // フォルダの名前
    var folderName: String!
    
    @IBAction func addFolder(_ sender: Any) {
        print("フォルダー追加ボタンが押されました")
        
        // Alertを作成
        // こちらのデフォルトで決まっているものはConst.swiftなど(Lesson8参照)の定数をまとめて宣言する場所に固めておいておくと管理しやすいですよ
        let alert = UIAlertController(title: "新規フォルダ", message: "フォルダの名前を入力してください", preferredStyle: .alert)
        
        // OKアクションを生成
        let defaultAction = UIAlertAction(title: "保存", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            print("保存ボタンが押されました")
            /// テキストが入力されていれば表示
            if let textFields = alert.textFields {
                
                // アラートに含まれるすべてのテキストフィールドを調べる
                /*
                 ここが少し危険かもしれませんね。
                 もしFolderの他にFolderの説明文も追加するようであれば、
                 確実にバグると思います。(要はAlertのTextFieldを殖やす場合ですね)
                */
                for textField in textFields {
                    print("「\(textField.text!)」フォルダが追加されました")
                    self.folders.append(textField.text!)
                    // TableViewを再読み込み.
                    self.tableView.reloadData()
                }
            }
        })
        alert.addAction(defaultAction)
        
        // Cancelアクションを生成
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // TextFieldを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "名前"
            textField.returnKeyType = .done
        })
        
        // シミュレータの種類によっては、これがないと警告が発生
        alert.view.setNeedsLayout()
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
        
        // TableViewを再読み込み.
        tableView.reloadData()
    }
    
    @IBAction func editFolder(_ sender: Any) {
        // ここのEditボタン押したタイミングでEditボタンの文言を変えたほうがユーザーに親切でいいと思いますよ
        print("フォルダー編集ボタンが押されました")
        if isEditing {
            super.setEditing(false, animated: true)
            tableView.setEditing(false, animated: true)
        } else {
            super.setEditing(true, animated: true)
            tableView.setEditing(true, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSourceプロトコルのメソッド
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    /// 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderTableViewCell", for: indexPath)
        cell.textLabel?.text = "\(folders[indexPath.row])"
        return cell
    }
    
    // MARK: UITableViewDelegateプロトコルのメソッド
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ※1 ここでprepareにしているため folderNumber,folderNameとされておりますが、
        // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
        // を用いて遷移するとプロパティとして保持する必要がなくなるかと思いますよ
        folderNumber = indexPath.row
        folderName = folders[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showSongListVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSongListVC" {
            let songListVC = segue.destination as! SongListViewController
            songListVC.folderNumber = self.folderNumber
            songListVC.folderName = self.folderName
            print("（「遷移前）遷移元のセルは \(self.folderNumber) 番目の「\(self.folderName)」フォルダ")
        }
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            folders.remove(at: indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    // セルの並び替えを有効にする
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
