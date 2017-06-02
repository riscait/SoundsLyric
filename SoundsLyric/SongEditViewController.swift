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
    
    @IBAction func titleTextField(_ sender: Any) {
    }
    
    // 曲の情報を受け取る変数
    var song: Song!
    
    
    // MARK: - 歌詞を追加する
//    @IBAction func addLyric(_ sender: Any) {
//        let lyric = Lyric()
//        
//        lyric.owner = song
//        
//        // 今ある最大のidに１を足した数をidに設定
//        lyric.id = self.newId(model: lyric)!
//        
//        let lyricD = Lyric()
//        lyricD.owner = song
//        lyricD.id = self.newId(model: lyricD)!
//        lyricD.name = "Dメロ"
//        lyricD.text = ""
//        
//        // リレーション挿入
//        song.lyrics.append(lyricD)
//        
//        // Realmに保存
//        try! realm.write {
//            // 最後に配列へ追加
//            // FIXME: lyrics.append(lyricD)
//            
//            // 新規作成
//            realm.add(lyricD, update: true)
//        }
//        
//    }
    
    //MARK: - ViewController ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultPageMenu()
        
        setAudioRecorder()
        
        // 曲名をTextFieldに反映
        titleTextField.text = song.title
                
        // タイトルが空欄ならタイトル欄にキーボードフォーカス
        if titleTextField.text == "" {
            titleTextField.becomeFirstResponder()
        }
}
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // ここで音許可を聞いた方が良いと思う(許可されていない時にAV系扱うと落ちることが多いため)
        DispatchQueue.main.async {
            // 音声許可の確認
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { granted in
                // TODO: もし許可が得られなかった場合、録音ボタン再生ボタンを消した方が良い
                if granted {
                    print("\(#function) >>> マイク許可されましたよー")
                } else {
                    print("\(#function) >>> マイク許可できなかったでやんすー")
                }
            })
        }
    }

    
    // MARK: - AVAudioRecorderとPlayerで音声を録音再生する
    
    /// AVAudioRecorderをインスタンス化
    var audioRecorder: AVAudioRecorder?
    
    /// AudioRecorderを設定
    private func setAudioRecorder() {
        
        /// 録音の設定
        let recorderSettings: [String: Any] = [
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: 44100.0
        ]
        
        do {
            /// 録音可能カテゴリに設定する
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            // レコーダー設定
            try audioRecorder = AVAudioRecorder(url: self.documentFilePath(), settings: recorderSettings)
            
            // デリゲートは生成後設定
            audioRecorder?.delegate = self
            // 録音中に音量を取るか否か
            audioRecorder?.isMeteringEnabled = true
            
            // 録音ファイルの準備（すでにファイルがあれば上書き）
            // prepareは準備なので初期設定のが良い->ファイル名変更なので新規で必要な場合は生成し直した方が良いかも
            audioRecorder?.prepareToRecord()
            
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
    
    /// AVAudioPlayerをインスタンス化
    var audioPlayer: AVAudioPlayer?
    
    // ファイル保存名
    let fileName = "sectionA.caf" // TODO: String(format: "section%d.m4a", lyric.id)
    
    /// FileManagerをインスタンス化
    let fileManager = FileManager()
    
    /// 録音開始・停止するボタン
    @IBOutlet weak var recordingButton: UIBarButtonItem!
    @IBAction func recordingButton(_ sender: Any) {
        print("録音ボタンが押された")
        
        /// 録音中か否か
        if let isAudioRecorder = audioRecorder?.isRecording {
            if isAudioRecorder {
                print("\(isAudioRecorder): 録音中だったので録音停止する")
                audioRecorder?.stop()
                recordingButton.image = UIImage(named: "StartRecordingButton")
            } else {
                print("\(isAudioRecorder): 録音停止中だったので録音開始する")
                do {
                    // アクティブ
                    try AVAudioSession.sharedInstance().setActive(true)
                    // 録音開始
                    audioRecorder?.record()
                    print("RECORDING")
                } catch {
                    print("レコード失敗")
                }
                
                print("\(#function) >>> audioRecorder?.isRecording >>> \(String(describing: audioRecorder?.isRecording))")
                print("\(#function) >>> audioRecorder?.url >>> \(String(describing: audioRecorder?.url.absoluteString))")
                
                // 録音ボタンの画像をストップ画像にする
                recordingButton.image = UIImage(named: "StopRecordingButton")
            }
        }
    }
    
    @IBOutlet weak var playSound: UIBarButtonItem!
    @IBAction func playSound(_ sender: Any) {
        // 一旦再生確認
        do {
            // 録音ストップ
            audioRecorder?.stop()
            recordingButton.image = UIImage(named: "StartRecordingButton")
            
            print("\(#function) >>> audioRecorder?.isRecording >>> \(String(describing: audioRecorder?.isRecording))")
            
            if let url = audioRecorder?.url {
                print("\(#function) >>> \(url.absoluteString)から再生")
                // 再生インスタンス生成
                try audioPlayer = AVAudioPlayer(contentsOf: url)
            }
        } catch {
            print("再生時にerror出たよ(´・ω・｀)")
        }
        audioPlayer?.play()
    }
    
    /// 録音を開始するメソッド
    private func startRecord() {
        
    }
    
    /// 録音を停止するメソッド
    private func stopRecord() {

    }
    
    // 音声を再生するメソッド
    private func startPlay() {

    }
    
    // 音声をストップするメソッド
    private func stopPlay() {

    }
    
    // MARK: - PageMenu（ライブラリ使用）
    //　PageMenuの準備
    var pagemenu: CAPSPageMenu?
    
    /// デフォルトで表示するPageMenu項目を設定
     func setDefaultPageMenu() {
        /// Storyboardをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 画面配列の初期化
        var viewControllers: [UIViewController] = []
        
        
        // 存在する歌詞の数だけPageMenu用のコントローラーに画面を追加
        for lyric in song.lyrics {
            let songEditChildVC = storyboard.instantiateViewController(withIdentifier: "SongEditChildVC") as! SongEditChildViewController
            songEditChildVC.lyric = lyric
            // 歌詞セクションの名前を設定
            songEditChildVC.title = lyric.name
            
            viewControllers.append(songEditChildVC)
        }
        
        let pageMenuEditVC = storyboard.instantiateViewController(withIdentifier: "PageMenuEditVC") as! PageMenuEditViewController
        pageMenuEditVC.title = "Edit"
        pageMenuEditVC.lyrics = song.lyrics
        
        // viewControllersに追加
        viewControllers.append(pageMenuEditVC)
        
        /// PageMenuのカスタマイズ
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(#colorLiteral(red: 0.9764705896, green: 0.9236108219, blue: 0.7253268245, alpha: 1)),         // Menuの背景色
            .selectedMenuItemLabelColor(#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)),        // 選択中Menuの文字色
            .unselectedMenuItemLabelColor(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)),      // 未選択Menuの文字色
            .selectionIndicatorColor(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)),           // 選択中Menuのインジケーター色
            .menuHeight(40),
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
        pagemenu = CAPSPageMenu(viewControllers: viewControllers, frame: CGRect(x: 0, y:topBarsHeight, width: self.view.frame.width, height: self.view.frame.height - topBarsHeight) , pageMenuOptions: parameters)
        
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
        print("録音が終了しました")
    }
}
