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
    /*
     これConst(定数)っていう概念とは少し違いますね
     基本的にはスカラーの値などだけで用いたほうがよろしいかと
     それで言うとこれは以下のように作って用いると良いかと思いますよ
     */
    static let alertAddFolder = UIAlertController(title: "新規フォルダ", message: "フォルダの名前を入力してください", preferredStyle: .alert)
}
/*
 こんな感じですね
 呼び出す際は `let alert = AlertUtil.createAddedAlertController(createName: "新規フォルダ")`
class AlertUtil {
    
    class func createAddedAlertController(createName: String) -> UIAlertController {
        return UIAlertController(title: createName, message: "\(createName)の名前を入力してください", preferredStyle: .alert)
    }
}
 */
