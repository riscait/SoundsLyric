//
//  SongEditViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/04/29.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import PageMenu
import RealmSwift

class SongEditViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    // Realmをインスタンス化
    let lyric = Lyric()
    
    
    //　PageMenuの準備
    var pagemenu: CAPSPageMenu?
    
    // 曲の情報を受け取る変数
    var song: Song!
    
    /// Viewを格納する配列
    var controllerArray: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarの枠線を消す
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setDefaultPageMenu()

        // 曲名をTextFieldに反映
        titleTextField.text = song.title
        
        // タイトルが空欄ならタイトル欄にキーボードフォーカス
        if titleTextField.text == "" {
            titleTextField.becomeFirstResponder()
        }
    }
    
    /// 画面が消える直前に呼び出されるメソッド
    ///
    /// - Parameter animated: animated
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.writeRealmDB(model: song)
        
        try! realm.write {
            // 曲のタイトルを保存
            self.song.title = titleTextField.text!
            // 現在時刻を更新時刻として保存
            self.song.date = NSDate()
            
        }
    }
    
    
    // キーボードを閉じるボタンを押した時に呼ばれる
    @IBAction func closeKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// デフォルトで表示するPageMenu項目を設定
    fileprivate func setDefaultPageMenu() {
        /// Storyboardをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        /// １つ目の画面をインスタンス化
        let songEditChildVCFirst = storyboard.instantiateViewController(withIdentifier: "SongEditChildVC") as! SongEditChildViewController
        songEditChildVCFirst.lyricType = 1
        songEditChildVCFirst.title = "Aメロ"
        songEditChildVCFirst.view.backgroundColor = UIColor.white
        controllerArray.append(songEditChildVCFirst)
        
        /// ２つ目の画面をインスタンス化
        let songEditChildVCSecond = storyboard.instantiateViewController(withIdentifier: "SongEditChildVC") as! SongEditChildViewController
        songEditChildVCSecond.lyricType = 2
        songEditChildVCSecond.title = "Bメロ"
        songEditChildVCSecond.view.backgroundColor = UIColor.cyan
        controllerArray.append(songEditChildVCSecond)
        
        /// ３つ目の画面をインスタンス化
        let songEditChildVCThird = storyboard.instantiateViewController(withIdentifier: "SongEditChildVC") as! SongEditChildViewController
        songEditChildVCThird.lyricType = 3
        songEditChildVCThird.title = "サビ"
        songEditChildVCThird.view.backgroundColor = UIColor.yellow
        controllerArray.append(songEditChildVCThird)
        
        /// PageMenuのカスタマイズ
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .selectedMenuItemLabelColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor.lightGray),
            .selectionIndicatorColor(UIColor.orange),
            .menuItemSeparatorColor (UIColor.cyan),
            .menuHeight(25),
            .menuItemSeparatorWidth(0),
            .useMenuLikeSegmentedControl(true),
        ]
        
        // StatusBarの高さを取得
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        // NavigationBarの高さを取得
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        // 二つのBarの大きさ
        let topBarsHeight = statusBarHeight + navigationBarHeight! + titleTextField.frame.height
        
        
        // 初期化（表示するVC / 位置・大きさ / カスタマイズ内容）
        pagemenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y:topBarsHeight, width: self.view.frame.width, height: self.view.frame.height - topBarsHeight) , pageMenuOptions: parameters)
        
        // PageMenuを表示する
        self.view.addSubview(pagemenu!.view)
        
        // PageMenuのViewを背面に移動
        self.view.sendSubview(toBack: pagemenu!.view)

    }
}

// MARK: - SongEditChildViewControllerDelegate
extension SongEditViewController: SongEditChildVCDelegate {
    
    func writeLyricToDB() {
    }
}
