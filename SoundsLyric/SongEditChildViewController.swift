//
//  SongEditChildViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/11.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift

/// セクションごとの歌詞を書くVC
class SongEditChildViewController: BaseViewController {
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    var lyric: Lyric!
    
    
    /// 歌詞のタイプ
    var lyricSectionID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("lyricの内容：\(lyric)")
        
        // realmの値を反映
        bodyTextView.text = lyric.text
        
        // ボタンを表示するためのViewを作成する
        let keyboardToolView = UIView()
        keyboardToolView.frame.size.height = 44
        keyboardToolView.backgroundColor = UIColor.clear
        // キーボードを閉じるボタンを作成する（画像は任意のものを）
        let closeKeyboardButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 70, y: 0, width: 70, height: 44))
        closeKeyboardButton.setImage(UIImage(named: "DismissKeyboardButton"), for: .normal) // 通常時のボタン設定
        closeKeyboardButton.addTarget(self, action: #selector(closeKeyboard), for: .touchUpInside) // タッチしてそのまま離したら
        // Viewに閉じるButtonを追加する
        keyboardToolView.addSubview(closeKeyboardButton)
        // システムキーボードの上にViewを追加する
        bodyTextView.inputAccessoryView = keyboardToolView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver() // Notificationを画面が消えるときに削除

        // 画面が消える直前にrealmに保存
        try! realm.write {
            lyric.name = self.title!
            lyric.text = bodyTextView.text
            self.realm.add(self.lyric, update: true)
        }
    }
    
    // MARK: - Keyboard関係メソッド
    /// キーボードを下げる
    func closeKeyboard() {
        self.view.endEditing(true)
    }

    /// Notificationを設定
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /// Notificationを削除
    func removeObserver() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    /// キーボードが現れた時に、画面全体をずらす。
    func keyboardWillShow(notification: Notification?) {
        let info = notification!.userInfo!
        let value = info[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = value.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left:0, bottom:keyboardSize.height+40, right:0)
        bodyTextView.contentInset = contentInsets
    }
    
    /// キーボードが消えたときに、画面を戻す
    func keyboardWillHide(notification: Notification?) {
        bodyTextView.contentInset = UIEdgeInsets.zero
    }
}
