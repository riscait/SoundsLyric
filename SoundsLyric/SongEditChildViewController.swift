//
//  SongEditChildViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/11.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift
/*
 継承は全てBaseViewControllerですかね
 class FolderViewController: BaseViewController {
 */
/// セクションごとの歌詞を書くVC
class SongEditChildViewController: UIViewController {

//    var delegate: SongEditChildVCDelegate?
    
    @IBOutlet weak var textView: UITextView!
    
    var lyric: Lyric!
    
    /// 歌詞のタイプ
    var lyricSectionID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // realmの値を反映
        self.title = lyric.name
        textView.text = lyric.text
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 画面が消える直前にrealmに保存
//        try! realm.write {
//            lyric.name = self.title!
//            lyric.text = textView.text
//            self.realm.add(self.lyric, update: true)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITextViewDelegate
extension SongEditChildViewController: UITextViewDelegate {
    
    /// TextViewの編集が終了したときの処理
    ///
    /// - Parameter textView: textView
    func textViewDidEndEditing(_ textView: UITextView) {
//        if let delegate = self.delegate {
//            delegate.writeLyricToDB()
//        }
    }
}
