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
    
    // SongListVCから受け取った曲情報
    var songName:String!
    
    /// Viewを格納する配列
    var controllerArray: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultPageMenu()

        // NavBarのタイトルに曲名を反映
        navigationItem.title = songName
    }
    
    /// デフォルトで表示するPageMenu項目を設定
    private func setDefaultPageMenu() {
        /// １つ目の画面
        let controllerA = UIViewController()
        controllerA.title = "Aメロ"
        controllerA.view.backgroundColor = UIColor.white
        controllerArray.append(controllerA)
        let textView = UITextView(frame: CGRect(x: 100, y: 100, width: 150, height: 150))
        textView.backgroundColor = UIColor.magenta
        textView.text = "1234567890abcdefghijklmnopqrstuwxyz 1234567890 abcdefghijklmnopqrstuwxyz \na\nb\nc\ndefghijklmnopqrstuwxyz \n http://www.gclue.com\n"
        textView.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(textView)
        
        
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
        
        /// PageMenuのカスタマイズ
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.lightGray),
            .selectedMenuItemLabelColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor.gray),
            .selectionIndicatorColor(UIColor.red),
            .menuItemSeparatorColor (UIColor.cyan),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 14.0)!),
            .menuItemSeparatorRoundEdges(true)
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
