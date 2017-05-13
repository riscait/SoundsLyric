//
//  Song.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/13.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import RealmSwift

class Song: Object {
    // 管理用ID（プライマリーキー）
    dynamic var id = 0
    
    dynamic var title = ""
    
    dynamic var contents = ""
    
    dynamic var date = NSDate()
    
    // idをプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
