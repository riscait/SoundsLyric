//
//  SongEditChildViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/11.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit

class SongEditChildViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    /// 歌詞のタイプ
    var lyricType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
