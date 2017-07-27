//
//  JigsawMainViewController.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/21.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

class SudokuMainViewController: UIViewController {
    
    //MARK:lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "数独22"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:-触摸事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        let clickPoint = touch.location(in:self.view)     //获取当前点击位置
        
        
    }
    /*
        1.判断拼图是否完成
        2.判断此位置是否可移动
        3.
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        let clickPoint = touch.location(in:self.view)     //获取当前点击位置
        
        
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
