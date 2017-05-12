//
//  SongEditViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/04/29.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import PageMenu

class SongEditViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func closeKeyboard(_ sender: Any) {
        
    }
    
    var pagemenu: CAPSPageMenu?
    
    /// Viewを格納する配列
    var controllerArray: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultPageMenu()

        // NavBarのタイトルに曲名を反映
        navigationItem.title = Const.songName
        
    }
    
    /// デフォルトで表示するPageMenu項目を設定
    private func setDefaultPageMenu() {
        // Storyboardをインスタンス化して、Storyboard上のVCを取得する
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let songEditChildVC = storyboard.instantiateViewController(withIdentifier: "SongEditChildVC")
        
        /// １つ目の画面
        let controllerA = songEditChildVC
        controllerA.title = "Aメロ"
        controllerA.view.backgroundColor = UIColor.white
        controllerArray.append(controllerA)
        
        /// ２つ目の画面
        let controllerB = UIViewController()
        controllerB.title = "Bメロ"
        controllerB.view.backgroundColor = UIColor.cyan
        controllerArray.append(controllerB)
        
        /// ３つ目の画面
        let controllerC = UIViewController()
        controllerC.title = "Cメロ"
        controllerC.view.backgroundColor = UIColor.yellow
        controllerArray.append(controllerC)
        
        /// PageMenuのカスタマイズ
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .selectedMenuItemLabelColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor.lightGray),
            .selectionIndicatorColor(UIColor.orange),
            .menuItemSeparatorColor (UIColor.cyan),
            .menuItemSeparatorWidth(0),
            .useMenuLikeSegmentedControl(true),
        ]
        
        // StatusBarの高さを取得
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        // NavigationBarの高さを取得
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        // 二つのBarの大きさ
        let topBarsHeight = statusBarHeight + navigationBarHeight!
        
        
        // 初期化（表示するVC / 位置・大きさ / カスタマイズ内容）
        pagemenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y:topBarsHeight, width: self.view.frame.width, height: self.view.frame.height - topBarsHeight) , pageMenuOptions: parameters)
        
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
