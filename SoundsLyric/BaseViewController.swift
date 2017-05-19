//
//  BaseViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/15.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit
import RealmSwift

class BaseViewController: UIViewController {

    // Realmをインスタンス化
    let realm = try! Realm()
    
    /// Realmに書き込み(更新も)
    ///
    /// - Parameter model: Object継承型
    /// - Returns: true
    func writeRealmDB<T: Object>(model: T) -> Bool {
        do {
            try realm.write {
                realm.add(model, update: true)
            }
            return true
        } catch let error as NSError {
            print(error.description)
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
