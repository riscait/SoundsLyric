//
//  Const.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/13.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import Foundation
import UIKit

struct Const {
    // Alertを作成
    static let alertAddFolder = UIAlertController(title: "新規フォルダ", message: "フォルダの名前を入力してください", preferredStyle: .alert)
    static let alertAddSong = UIAlertController(title: "新らしい曲", message: "曲の名前を入力してください", preferredStyle: .alert)
    // フォルダの配列
    static var folders = ["最初にあるフォルダ"]
    // 曲の名前
    static var songName = "新しい曲"
}
