//
//  SongEditChildViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/11.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift

/// SongEditChildVCDelegate
protocol SongEditChildVCDelegate {
    func writeLyricToDB()
}

/// セクションごとの歌詞を書くVC
class SongEditChildViewController: UIViewController {

    var delegate: SongEditChildVCDelegate?
    
    @IBOutlet weak var textView: UITextView!
    
    let realm = try! Realm()
    let lyric = Lyric()
    
    var song: Song!
    
    /// 歌詞のタイプ
    var lyricType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        if let delegate = self.delegate {
            delegate.writeLyricToDB()
        }
    }
}
