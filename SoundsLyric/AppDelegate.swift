//
//  AppDelegate.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/04/28.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults()

    // アプリ起動時に呼び出されるメソッド
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 初回起動処理
        let dic = ["initialLaunch": true]
        defaults.register(defaults: dic)
        defaults.synchronize()
        
        if defaults.bool(forKey: "initialLaunch") {
            print("初回起動です")
            self.initialSetup()
        }
        
        return true
    }
    
    func initialSetup() {
        // 初回マイグレーション
        self.realmMigration()
        // シードデータ挿入
        self.insertSeedData()
        // 初回起動済みのフラグを立てる
        self.defaults.set(false, forKey: "initialLaunch")
        self.defaults.synchronize()
    }
    
    func realmMigration() {
        let config = Realm.Configuration(
            // 新しいスキーマバージョンを設定します。以前のバージョンより大きくなければなりません。
            // （スキーマバージョンを設定したことがなければ、最初は0が設定されています）
            schemaVersion: 1,
            
            // マイグレーション処理を記述します。古いスキーマバージョンのRealmを開こうとすると
            // 自動的にマイグレーションが実行されます。
            migrationBlock: { migration, oldSchemaVersion in
                // 最初のマイグレーションの場合、`oldSchemaVersion`は0です
                if (oldSchemaVersion < 1) {
                    // 何もする必要はありません！
                    // Realmは自動的に新しく追加されたプロパティと、削除されたプロパティを認識します。
                    // そしてディスク上のスキーマを自動的にアップデートします。
                }
        })
        
        // デフォルトRealmに新しい設定を適用します
        Realm.Configuration.defaultConfiguration = config
        
        // Realmファイルを開こうとしたときスキーマバージョンが異なれば、
        // 自動的にマイグレーションが実行されます
        let realm = try! Realm()
    }
    
    func insertSeedData() {
        let realm = try! Realm()
        // デモ用のフォルダ、曲、歌詞を作成
        let folder = Folder()
        folder.id = 1
        folder.title = "My Songs"
        let song = Song()
        song.owner = folder
        song.id = 1
        song.title = "First song"
        song.date = NSDate()
        let lyric = Lyric()
        lyric.owner = song
        lyric.id = 1
        lyric.name = "Aメロ"
        lyric.text = "ここに歌詞を書いてください"
        
        try! realm.write {
            realm .add(folder, update: true)
            realm .add(song, update: true)
            realm .add(lyric, update: true)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

