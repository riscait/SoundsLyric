//
//  SongEditChildViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/11.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol SongEditChildVCDelegate {
    @objc optional func enableButtonCloseKeyboard()
}

/// セクションごとの歌詞を書くVC
class SongEditChildViewController: BaseViewController {
    
    var delegate: SongEditChildVCDelegate?
    
    @IBOutlet weak var textView: UITextView!
    
    var lyric: Lyric!
    
    /// 歌詞のタイプ
    var lyricSectionID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("lyricの内容：\(lyric)")
        
        // realmの値を反映
        textView.text = lyric.text
        
        let keyboardToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        keyboardToolBar.barStyle = UIBarStyle.default
        keyboardToolBar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let closeKeyboardButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "closeKeyboard")
        
        keyboardToolBar.items = [spacer, closeKeyboardButton]
        
        textView.inputAccessoryView = keyboardToolBar
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

// MARK: - UITextViewDelegate
extension SongEditChildViewController: UITextViewDelegate {
    
    /// テキストビューの編集が開始された時のメソッド
    ///
    /// - Parameter textView: textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditingが呼ばれました")
        if let delegate = self.delegate {
            delegate.enableButtonCloseKeyboard!()
            print("enableButtonCloseKeyboardが呼ばれました")
        }
}
    
    /// TextViewの編集が終了したときの処理
    ///
    /// - Parameter textView: textView
    func textViewDidEndEditing(_ textView: UITextView) {
//        if let delegate = self.delegate {
//            delegate.writeLyricToDB()
//        }
    }
}
