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
    
    @IBOutlet weak var closeKeyboard: UIBarButtonItem!
    
    /// 歌詞セクションを追加するボタン
    ///
    /// - Parameter sender: Any
    @IBAction func addLyric(_ sender: Any) {
        let lyric = Lyric()
        
        lyric.owner = song
        
        // 今ある最大のidに１を足した数をidに設定
        lyric.id = self.newId(model: lyric)!
        
        let lyricD = Lyric()
        lyricD.owner = song
        lyricD.id = self.newId(model: lyricD)!
        lyricD.name = "Dメロ"
        lyricD.text = ""
        
        // リレーション挿入
        song.lyrics.append(lyricD)
        
        // Realmに保存
        try! realm.write {
            // 最後に配列へ追加
// FIXME:           lyrics.append(lyricD)
            
            // 新規作成
            realm.add(lyricD, update: true)
        }
        
    }

    /// 歌詞(TextView)入力中ならボタンが表示されて、押したらキーボードが閉じる
    ///
    /// - Parameter sender: Any
    @IBAction func closeKeyboard(_ sender: Any) {
        view.endEditing(true)
        
        // TODO: TextView編集中のみボタンが現れるメソッドが必要。押したらまた非表示にする。
    }
    
    /// 録音の開始、一時停止ボタンのメソッド
    ///
    /// - Parameter sender: Any
    @IBAction func startAndStopRecording(_ sender: Any) {
        print("録音ボタンが押された")
        
        /// 録音中か否か
        if let isAudioRecorder = audioRecorder?.isRecording {
            if isAudioRecorder {
                print("\(isAudioRecorder): 録音中だったので録音停止する")
                audioRecorder?.stop()
                recordingButton.image = UIImage(named: "StartRecordingButton")
            } else {
                print("\(isAudioRecorder): 録音停止中だったので録音開始する")
                // 録音ファイルの準備（すでにファイルがあれば上書き）
                audioRecorder?.prepareToRecord()
                // 録音中に音量を取るか否か
                audioRecorder?.isMeteringEnabled = true
                // 録音開始
                audioRecorder?.record()
                // 録音ボタンの画像をストップ画像にする
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
    
    let fileName = "sectionA.m4a"
    let fileManager = FileManager()
    
    /// AVAudioPlayerをインスタンス化
    var audioPlayer: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioRecorder?.delegate = self
        
        // NavigationBarの枠線を消す
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setDefaultPageMenu()
        
        setAudioRecorder()

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
    
    /// AudioRecorderを設定
    private func setAudioRecorder() {
        
        /// 録音可能カテゴリに設定する
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch  {
            // エラー処理
            fatalError("カテゴリ設定失敗")
        }
        
        // audioSessionのアクティブ化
        do {
            try audioSession.setActive(true)
        } catch  {
            // audioSession有効か失敗時の処理
            fatalError("audioSession有効化失敗")
        }
        
        /// 録音の設定
        let recorderSettings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: 44100.0
        ]

        do {
            try audioRecorder = AVAudioRecorder(url: self.documentFilePath(), settings: recorderSettings)
            print("録音ファイルの保存場所: \(self.documentFilePath())")
        } catch {
            print("初期設定でエラー")
        }
        
    }
    
    /// URLを取得？
    ///
    /// - Returns: URL
    func documentFilePath() -> URL {
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask) as [URL]
        let dirURL = urls[0]
        
        return dirURL.appendingPathComponent(fileName)
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
        print("録音が終了しました")
    }
    
}
