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

    override func viewDidLoad() {
        
        // NavigationBarの枠線を消す
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // 背景画像を設定
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
    }
    
    // Realmをインスタンス化
    let realm = try! Realm()
    
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
    
    func newId<T: Object>(model: T) -> Int? {
        guard let key = T.primaryKey() else { return nil }
        
        if let last = realm.objects(T.self).last,
            let lastId = last[key] as? Int {
            return lastId + 1
        } else {
            return 0
        }
    }
}
