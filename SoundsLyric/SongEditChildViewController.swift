//
//  SongEditChildViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/11.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift

class SongEditChildViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    let realm = try! Realm()
    
    var song: Song!
    
    /// 歌詞のタイプ
    var lyricType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            // 歌詞の保存
// FIXME:           self.song.contents = textView.text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITextViewDelegate
extension SongEditChildViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
