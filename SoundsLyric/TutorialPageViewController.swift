//
//  TutorialPageViewController.swift
//  SoundsLyric
//
//  Created by 村松龍之介 on 2017/05/07.
//  Copyright © 2017年 ryunosuke.muramatsu. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageViewControllerArray: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

        // 各ページをインスタンス化
        let firstTutorialViewController: FirstTutorialViewController = storyboard!.instantiateViewController(withIdentifier: "FirstTutorial") as! FirstTutorialViewController
        let secondTutorialViewController: SecondTutorialViewController = storyboard!.instantiateViewController(withIdentifier: "SecondTutorial") as! SecondTutorialViewController
        let thirdTutorialViewController: ThirdTutorialViewController = storyboard!.instantiateViewController(withIdentifier: "ThirdTutorial") as! ThirdTutorialViewController
        
        /// 全ページが入った配列
        pageViewControllerArray = [firstTutorialViewController, secondTutorialViewController, thirdTutorialViewController]
        //  UIPageControllerに表示対象を追加
        setViewControllers([pageViewControllerArray[0]], direction: .forward, animated: false, completion: nil)
    }
    
    /// 右にスワイプした場合のメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 今表示しているページ数を取得する
        let index = pageViewControllerArray.index(of: viewController)
            // 最初のページでなければページを一つ戻す
        if index != 0 {
            return pageViewControllerArray[index! - 1]
        } else {
            return nil
        }
    }
    
    /// 左にスワイプした場合のメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // 今表示しているページ数を取得する
        let index = pageViewControllerArray.index(of: viewController)
            // 最終ページでなければページを一つ進める
        if index != pageViewControllerArray.count - 1 {
            return pageViewControllerArray[index! + 1]
        } else {
            return nil
        }
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
