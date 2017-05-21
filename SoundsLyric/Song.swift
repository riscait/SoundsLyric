//
//  Song.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/13.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import RealmSwift

/// Folder model
class Folder: Object {
    
    /// 「フォルダ」は多数の「曲」を持つ
    let songs = List<Song>()
    
    /// 管理用ID（プライマリーキー）
    dynamic var id = 0

    /// フォルダの名前
    dynamic var title = ""

    /// idをプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}

/// Song model
class Song: Object {
    
    /// 親は「Folder」
    dynamic var owner: Folder?
    
    /// 「曲」は多数の「歌詞」を持つ
    let lyrics = List<Lyric>()
    
    /// 管理用ID（プライマリーキー）
    dynamic var id = 0
    
    /// 曲のタイトル
    dynamic var title = ""
    
    /// 曲の編集更新時刻
    dynamic var date = NSDate()
    
    /// idをプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}

/// Lyric model
class Lyric: Object {
    
    /// 親は「Song」
    dynamic var owner: Song?
    
    /// 管理用ID（プライマリーキー）
    dynamic var id = 0
    
    /// Aメロ、Bメロなど
    dynamic var name = ""
    
    /// 歌詞テキスト
    dynamic var text = ""
    
    /// Firebaseにある音声ファイルのURL
    dynamic var sound = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
