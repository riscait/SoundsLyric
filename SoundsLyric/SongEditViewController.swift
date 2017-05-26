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
    
    //　PageMenuの準備
    var pagemenu: CAPSPageMenu?
    
    // 曲の情報を受け取る変数
    var song: Song!
    
    /// Viewを格納する配列
    var controllerArray: [UIViewController] = []
    
    /// AVAudioRecorderをインスタンス化
    var audioRecorder: AVAudioRecorder?
    
    /*
     音声ファイル名は
     Lyric(歌詞ごとに録音でなければSong)のidを間に挟むとユニーク性が担保されるかなと思います
     ex: String(format: "section%d.m4a", lyric.id)
     */
    
    /*
     拡張子.m4aは無理なのかな...見た感じで来そうで色々試しましたが
     .cafで通りました。
     */
    let fileName = "sectionA.caf"
    
    let fileManager = FileManager()
    
    /// AVAudioPlayerをインスタンス化
    var audioPlayer: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ここはまだ設定前なので適応されない
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
    
    /// 表示後呼ばれる
    ///
    /// - Parameter animated: animated
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
        
        /// 録音の設定
        let recorderSettings: [String: Any] = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
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
    
    /// プレイ
    ///
    /// - Parameter sender: UIBarButtonItem
    @IBAction func play(_ sender: UIBarButtonItem) {
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
