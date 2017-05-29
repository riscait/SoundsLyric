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
        
        let keyboardToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        keyboardToolBar.sizeToFit()
        keyboardToolBar.isTranslucent = true
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        let closeKeyboardButton = UIBarButtonItem(image: UIImage(named: "DismissKeyboardButton"), style: .plain, target: self, action: #selector(closeKeyboard))
        closeKeyboardButton.tintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        
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
