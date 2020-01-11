//
//  DrawerViewController.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/12.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    
    var mainViewController:UINavigationController?
    var leftViewController:DrawerLeftTableViewController?
    var rightTableView:DrawerRightTableView?
    
    var speed_f:CGFloat = 0.5//滑动速率
    let mainVC_offset:CGFloat = 100//屏幕偏移极限
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "抽屉效果"
        self.view.backgroundColor = UIColor.white
        
        //视图加载
        self.leftViewController = DrawerLeftTableViewController()
        self.view.addSubview((leftViewController?.view)!)
        
        let farmeX = screenRect.width / 2
        let frame:CGRect = CGRect.init(x: farmeX, y: 64, width: screenRect.width - farmeX, height: screenRect.height-64);
        self.rightTableView = DrawerRightTableView(frame: frame)
        self.view.addSubview(rightTableView!)
        
        self.mainViewController = UINavigationController(rootViewController: DrawerMainViewController())
        self.view.addSubview((mainViewController?.view)!)
        
        //隐藏左右视图
        self.leftViewController?.view.isHidden = true
        self.rightTableView?.isHidden = true

        //添加滑动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(sender:)))
        self.mainViewController?.view.addGestureRecognizer(pan)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func panAction(sender: UIPanGestureRecognizer){
        //获取手指位置
        let point = sender.translation(in: sender.view)
        if point.x < -mainVC_offset{
            //向左滑
            self.leftViewController?.view.isHidden = true
            self.rightTableView?.isHidden = false
            
            self.showRightView()
            
        }else if point.x > mainVC_offset{
            //向右滑
            self.leftViewController?.view.isHidden = false
            self.rightTableView?.isHidden = true
            
            self.showLeftView()
            
        }else{
            self.showMainView()
        }
    }
    
    
    func showMainView(){
        //动画显示
        UIView.beginAnimations(nil, context: nil)
        
        //屏幕偏移计算
        self.mainViewController?.view.center = CGPoint(x: screenRect.width / 2, y: screenRect.height / 2)
        //提交动画
        UIView.commitAnimations()
    }
    func showLeftView(){
        UIView.beginAnimations(nil, context: nil)
        self.mainViewController?.view.center = CGPoint(x: screenRect.width * 1.5 - mainVC_offset, y: screenRect.height / 2)
        UIView.commitAnimations()
    }
    func showRightView(){
        UIView.beginAnimations(nil, context: nil)
        self.mainViewController?.view.center = CGPoint(x: mainVC_offset - screenRect.width / 2, y: screenRect.height / 2)
        
        let farmeX = screenRect.width / 2
        let frame:CGRect = CGRect.init(x: farmeX, y: 64, width: screenRect.width - farmeX, height: screenRect.height-64);
        rightTableView?.frame = frame;
        
        UIView.commitAnimations()
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
