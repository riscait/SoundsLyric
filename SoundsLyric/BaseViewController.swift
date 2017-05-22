//
//  BaseViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/15.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift

class BaseViewController: UIViewController {

    // Realmをインスタンス化
    let realm = try! Realm()
    
    /**
     以下のメソッドは親となるVCに組み込むのではなく、
     厳密にはObject->自作BaseObjectクラス(ここに組み込む)->Song,Lyric,Folder
     とした方がわかりやすいですし良いかもですね
     */
    
    /// Realmに書き込み(更新も)
    ///
    /// - Parameter model: Object継承型
    /// - Returns: true
    func writeRealmDB<T: Object>(model: T) -> Bool {
        do {
            try realm.write {
                realm.add(model, update: true)
            }
            return true
        } catch let error as NSError {
            print(error.description)
        }
        return false
    }
    
    
    /// 新規主キー発行
    ///
    /// - Parameter model: model
    /// - Returns: Int?
    func newId<T: Object>(model: T) -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            // ここはエラー投げてもいいかも(未設定はあり得ないので)
            return nil
        }
        
        if let last = realm.objects(T.self).last,
            let lastId = last[key] as? Int {
            return lastId + 1
        } else {
            return 0
        }
    }
}
