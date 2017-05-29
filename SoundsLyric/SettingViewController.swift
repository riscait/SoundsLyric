//
//  SettingViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/28.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationBarの背景を透過
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
}
