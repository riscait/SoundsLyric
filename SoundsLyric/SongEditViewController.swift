//
//  SongEditViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/04/29.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import AVFoundation
import PageMenu
import RealmSwift

class SongEditViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var recordingButton: UIBarButtonItem!
    
    @IBAction func startAndStopRecording(_ sender: Any) {
        print("録音ボタンが押されました")
        /// 録音中か否か
        if let isAudioRecorder = audioRecorder?.isRecording {
            if isAudioRecorder {
                print("録音中")
                audioRecorder?.pause()
                recordingButton.image = UIImage(named: "StartRecordingButton")
            } else {
                print("録音停止中")
                audioRecorder?.record()
                recordingButton.image = UIImage(named: "StopRecordingButton")
            }
        }
    }
    
    //　PageMenuの準備
    var pagemenu: CAPSPageMenu?
    
    // 曲の情報を受け取る変数
    var song: Song!
    
    /// Viewを格納する配列
    var controllerArray: [UIViewController] = []
    
    /// AVAudioRecorderをインスタンス化
    var audioRecorder: AVAudioRecorder?
    /// AVAudioPlayerをインスタンス化
    var audioPlayer: AVAudioPlayer?
    
    
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
        
        try! realm.write {
            // 曲のタイトルを保存
            song.title = titleTextField.text!
            // 現在時刻を更新時刻として保存
            self.song.date = NSDate()
            print("曲名と更新時刻を保存しました")
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
        
        // 存在する歌詞の数だけPageMenu用のコントローラーに画面を追加
        for lyric in song.lyrics {
            let songEditChildVC = storyboard.instantiateViewController(withIdentifier: "SongEditChildVC") as! SongEditChildViewController
            songEditChildVC.lyric = lyric
            // 歌詞セクションの名前を設定
            songEditChildVC.title = lyric.name
            controllerArray.append(songEditChildVC)
        }

        
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

// MARK: - AVAudioRecorderDelegate
extension SongEditViewController: AVAudioRecorderDelegate {
    
    /// 録音が終了、または時間制限に達した時に呼び出される
    ///
    /// - Parameters:
    ///   - recorder: 記録が終了したAudioRecorder
    ///   - flag: 記録が正常に終了したかどうか
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("録音が終了")
    }
    
}
