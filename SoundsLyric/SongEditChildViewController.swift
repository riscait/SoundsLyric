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
    
    @IBOutlet weak var textView: UITextView!
    
    var lyric: Lyric!
    
    /// 歌詞のタイプ
    var lyricSectionID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("lyricの内容：\(lyric)")
        
        // realmの値を反映
        textView.text = lyric.text
        
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
        textView.inputAccessoryView = keyboardToolView
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 画面が消える直前にrealmに保存
        try! realm.write {
            lyric.name = self.title!
            lyric.text = textView.text
            self.realm.add(self.lyric, update: true)
        }
    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
    }
}
