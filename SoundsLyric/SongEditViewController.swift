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
    
    /// Viewを格納する配列
    var controllerArray: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultPageMenu()

        /// PageMenuのカスタマイズ
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
    
    /// デフォルトで表示するPageMenu項目
    private func setDefaultPageMenu() {
        /// １つ目の画面
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
