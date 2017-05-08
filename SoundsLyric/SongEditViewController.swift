//
//  SongEditViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/04/29.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import PageMenu

class SongEditViewController: UIViewController {
    
    var pagemenu: CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Viewを格納する配列
        var controllerArray: [UIViewController] = []
        
        /**
         画面初期表示時にこのように書いていくことは
         viewDidLoad(viewWillAppear)が冗長になりがちなんです。
         なので、下の処理は外にprivate methodとして出してしまい、メソッドを分けることをお勧めします。
         setDefaultPageMenu()などとして外に出すとわかりやすいですよ
        **/
        
        /// １つ目の画面
        
        // 昨日のメンタリングにて話した通り、ここは自作の(歌詞を書くVC)に共通化できるので、よろしくお願いいたします！
        let controllerA = UIViewController()
        
        
        controllerA.title = "Aメロ"
        controllerA.view.backgroundColor = UIColor.black
        controllerArray.append(controllerA)
        
        /// ２つ目の画面
        let controllerB = UIViewController()
        controllerB.title = "Bメロ"
        controllerB.view.backgroundColor = UIColor.blue
        controllerArray.append(controllerB)
        
        /// ３つ目の画面
        let controllerC = UIViewController()
        controllerC.title = "Cメロ"
        controllerC.view.backgroundColor = UIColor.brown
        controllerArray.append(controllerC)
        
        // 編集画面も自作で必要になりますね
        
        /// カスタマイズ
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.yellow),
            .selectedMenuItemLabelColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor.gray),
            .selectionIndicatorColor(UIColor.red),
            .menuItemSeparatorColor (UIColor.cyan),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 14.0)!),
            .menuItemSeparatorRoundEdges(true)
        ]
        
        // 初期化
        pagemenu = CAPSPageMenu(viewControllers: controllerArray, frame: view.bounds, pageMenuOptions: parameters)
        
        // PageMenuを表示する
        self.view.addSubview(pagemenu!.view)
        
        // PageMenuのViewを背面に移動
        self.view.sendSubview(toBack: pagemenu!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
