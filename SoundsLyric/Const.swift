//
//  Const.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/13.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import Foundation
import UIKit

class AlertUtil {
    /// 新規アラートを作成
    /// e.g. let alert = AlertUtil.createAddedAlertController(createName: "新規フォルダ")
    /// - Parameter createName: アラートのタイトル
    /// - Returns: UIAlertController
    class func createAddedAlertController(createName: String) -> UIAlertController {
        return UIAlertController(title: createName, message: "\(createName)の名前を入力してください", preferredStyle: .alert)
    }
}

struct Const {
    /*
     VC=pageの重複バグは
     ここが静的に前の画面のVCも配列で保持しているため、発生していますね
     */
    static var sectionPages: [UIViewController] = []
}
