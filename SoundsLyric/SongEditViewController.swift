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
    
//    var lyricArray: List<Lyric>
    
    
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
    
    // MARK: - キーボードを閉じる
    @IBOutlet weak var closeKeyboard: UIBarButtonItem!
    @IBAction func closeKeyboard(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        // TODO: TextView編集中のみボタンが現れるメソッドが必要。押したらまた非表示にする。
    }
    
    //MARK: - ViewController ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarの枠線を消す
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setDefaultPageMenu()
        
        // 曲名をTextFieldに反映
        titleTextField.text = song.title
        
        closeKeyboard.isEnabled = false
        
        // タイトルが空欄ならタイトル欄にキーボードフォーカス
        if titleTextField.text == "" {
            titleTextField.becomeFirstResponder()
        }
        
        /// AVAudioEngineをインスタンス化
        audioEngine = AVAudioEngine()
        
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
    
    // MARK: - AVAudioEngineで音声を録音する
    // AVAudioEngine
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayer: AVAudioPlayerNode!
    var filePath: URL!
    var isPlaying = false
    var isRecording = false
    
    @IBOutlet weak var playSound: UIBarButtonItem!
    @IBAction func playSound(_ sender: Any) {
        if self.isPlaying {
            // 再生中の場合
            self.playSound.image = UIImage(named: "StopPlayButton")
            self.stopPlay()
        } else {
            // 再生中ではない場合
            self.playSound.image = UIImage(named: "StartPlayButton")
            self.startPlay()
        }
    }
    
    @IBOutlet weak var recordingButton: UIBarButtonItem!
    @IBAction func startAndStopRecording(_ sender: Any) {
        if isRecording {
            // 録音中の場合
            self.recordingButton.image = UIImage(named: "StartRecordingButton")
            stopRecord()
        } else {
            // 録音中ではない場合
            self.recordingButton.image = UIImage(named: "StopRecordingButton")
            startRecord()
        }
    }
    
    /// 録音を開始するメソッド
    private func startRecord() {
        
        // 録音中: true
        self.isRecording = true
        
        // AudioSession
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        // Mic(AVAudioInputNode)からBusミキサーへ接続する
        let mixer = self.audioEngine.mainMixerNode
        let input = self.audioEngine.inputNode
        self.audioEngine.connect(input!, to: mixer, format: input?.inputFormat(forBus: 0))
        
        
        do {
            // 録音ファイルを保存する場所
            let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
            self.filePath = URL(fileURLWithPath: documentDir + "/sound.caf") // TODO: lyric.idを使ったユニークなURLにする
            print("録音ファイルの場所は: \(self.filePath)")
            
            // オーディオフォーマット
            let format = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100.0, channels: 1, interleaved: true)
            
            // オーディオファイル
            let outputFile = try AVAudioFile(forWriting: self.filePath, settings: format.settings)
            
            // inputNodeの出力バス(インデックス0)にタップをインストール
            // installTapOnBusの引数formatにnilを指定するとタップをインストールしたノードの出力バスのフォーマットを使用する
            // (この例だとフォーマットに inputNode.outputFormatForBus(0) を指定するのと同じ)
            // tapBlockはメインスレッドで実行されるとは限らないので注意
            let inputNode = audioEngine.inputNode! // 端末にマイクがあると仮定する
            inputNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(format.sampleRate * 0.4), format: format, block: {(buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
                do {
                    // ファイルにバッファを書き込む
                    try outputFile.write(from: buffer)
                } catch let error {
                    print("バッファの書き込み失敗：audioFile.writeFromBuffer error:", error)
                }
            })
            
            do {
                // オーディオエンジンを開始
                try audioEngine.start()
                print("オーディオエンジンを開始しました")
            } catch let error {
                print("オーディオエンジン起動失敗：audioEngine.start() error:", error)
            }
        } catch let error {
            print("ファイル書き込み失敗：AVAudioFile error:", error)
        }
    }
    
    /// 録音を停止するメソッド
    private func stopRecord() {
        self.isRecording = false
        self.audioEngine.stop()
        self.audioEngine.inputNode?.removeTap(onBus: 0)
        try! AVAudioSession.sharedInstance().setActive(false)
        print("オーディオエンジンを終了しました")
    }
    
    private func startPlay() {
        self.isPlaying = true
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        self.audioFile = try! AVAudioFile(forReading: filePath)
        
        try! self.audioEngine.start()
        
    }
    
    private func stopPlay() {
        self.isPlaying = false
        
        self.audioEngine.stop()
        try! AVAudioSession.sharedInstance().setActive(false)
    }
    
    // MARK: - PageMenu（ライブラリ使用）
    //　PageMenuの準備
    var pagemenu: CAPSPageMenu?
    
    /// デフォルトで表示するPageMenu項目を設定
    fileprivate func setDefaultPageMenu() {
        /// Storyboardをインスタンス化
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // ここで画面配列の初期化
        var vcs: [UIViewController] = []
        
        // 存在する歌詞の数だけPageMenu用のコントローラーに画面を追加
        for lyric in song.lyrics {
            let songEditChildVC = storyboard.instantiateViewController(withIdentifier: "SongEditChildVC") as! SongEditChildViewController
            songEditChildVC.lyric = lyric
            // 歌詞セクションの名前を設定
            songEditChildVC.title = lyric.name
            
            /*
             ここで外部ソースに静的に保持させるではなく、
             このメソッド内でのローカル変数の持ち方でよろしいかと思います。
             ここで歌詞数分生成したSongEditVCを配列に追加
            */
//            print("Const.sectionPagesは\(Const.sectionPages)")
//            Const.sectionPages.append(songEditChildVC)
            vcs.append(songEditChildVC)
        }
        
        let pageMenuEditVC = storyboard.instantiateViewController(withIdentifier: "PageMenuEditVC") as! PageMenuEditViewController
        pageMenuEditVC.title = "編集"
        
        // これでPageMenu編集、追加のVCを宣言してますね。グッドです。
        // vcsに追加
//        var fullSectionPages: [UIViewController] = Const.sectionPages
//        fullSectionPages.append(pageMenuEditVC)
        vcs.append(pageMenuEditVC)
        
        
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
        // viewControllers=vcsにする
        pagemenu = CAPSPageMenu(viewControllers: vcs, frame: CGRect(x: 0, y:topBarsHeight, width: self.view.frame.width, height: self.view.frame.height - topBarsHeight) , pageMenuOptions: parameters)
        
        // PageMenuを表示する
        self.view.addSubview(pagemenu!.view)
        
        // PageMenuのViewを背面に移動
        self.view.sendSubview(toBack: pagemenu!.view)
        
    }
}

extension SongEditViewController: SongEditChildVCDelegate {

    func enableButtonCloseKeyboard() {
        closeKeyboard.isEnabled = true
    }

}
