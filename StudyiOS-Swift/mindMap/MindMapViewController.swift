//
//  MindMapViewController.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/6.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

class MindMapViewController: UIViewController {
    
    var rightTableView:MindMapRightTableView!
    var mindMapView:MindMapView!
    let mainVC_offset:CGFloat = 100//屏幕偏移极限
    /*
     记录最后一次打开过的key
     1.重新进入时自动选择上一次打开过的导图
     2.如果有打开，再次保存时选择原来的
     */
    var lastOpenKey:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,
                                         action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(rightBarItemAction))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        self.title = "思维导图"
        
        let lastKey = Tool.getUserDefaultValue(key: MINDMAPLASTOPENKEY)
        createMindMapView()
        createRightTableView()
        if lastKey.isEmpty {
            buildNewTree()
        }else{
            openSaveTree(key: lastKey)
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        if (lastOpenKey != nil) {
            Tool.saveUerDefault(key: MINDMAPLASTOPENKEY, value: lastOpenKey as AnyObject)
        }
        
    }
    
    @objc func backToPrevious(){
        
        self.navigationController?.popToRootViewController(animated: true);
        
    }
    
    //提示
    func saveMindMapAlertField() {
        
        let alertVC = UIAlertController(title: "提示", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action: UIAlertAction) -> Void in
            /**
             写取消后操作
             */
        })
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            (action: UIAlertAction) -> Void in
        
            let loginField = (alertVC.textFields?.first)! as UITextField
            var keyStr = ""
            if self.lastOpenKey == nil {
                if Tool.isEmptyStr(str: loginField.text!) {
                    keyStr = loginField.placeholder!
                }else{
                    keyStr = loginField.text!
                }
            }else{
                keyStr = self.lastOpenKey
            }
            
            self.lastOpenKey = keyStr
            
            let mindMapKeyDict = Tool.getUserDefaultDict(key: MINDMAPTREEKEY)
            mindMapKeyDict.setValue(self.mindMapView.mindMapTree.root as NSArray, forKey: keyStr)
            Tool.saveUerDefault(key: MINDMAPTREEKEY, value: mindMapKeyDict)
            
        })
        
        alertVC.addTextField {
            (textField: UITextField!) -> Void in
            if self.lastOpenKey == nil {
                textField.placeholder = Tool.getNowDate(formatDate: "yyyyMMddHHmmss")
            }else{
                textField.placeholder = self.lastOpenKey
            }
            
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        
        self.present(alertVC, animated: true, completion: nil)
        
        
    }
    
    //MARK:创建View
    func createRightTableView() {
        //添加抽屉效果
        let farmeX = screenRect.width / 2
        let frame:CGRect = CGRect.init(x: farmeX, y: 64, width: screenRect.width - farmeX, height: screenRect.height-64);
        self.rightTableView = MindMapRightTableView(frame: frame)
        self.view.addSubview(rightTableView!)
        
        self.rightTableView?.isHidden = true
        
        self.rightTableView?.callBack = { (type) in
            switch type {
            case .new:
                print("新建")
                if self.mindMapView != nil {
                    self.mindMapView.removeFromSuperview()
                    self.mindMapView = nil
                    
                    self.rightTableView.removeFromSuperview()
                    self.rightTableView = nil
                }
                self.createMindMapView()
                self.createRightTableView()
                self.buildNewTree()
            case .open:
                print("打开")
                let openListVC = MindMapOpenListTableViewController()
                openListVC.openListBlock = { (key) in
                    
                    if self.mindMapView != nil {
                        self.mindMapView.removeFromSuperview()
                        self.mindMapView = nil

                        self.rightTableView.removeFromSuperview()
                        self.rightTableView = nil
                    }
                    self.createMindMapView()
                    self.openSaveTree(key: key)
                    self.createRightTableView()
                }
                self.navigationController?.pushViewController(openListVC, animated: true)
                
            case .save:
                print("保存")
                self.saveMindMapAlertField()
                
            case .share:
                print("分享")
            case .snapshoot:
                print("快照")
                
            }
        }
    }
    
    func createMindMapView() {
        // Do any additional setup after loading the view.
        
        let viewFrame = CGRect.init(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height-64)
        mindMapView = MindMapView.init(frame: viewFrame)
        mindMapView.backgroundColor = UIColor.white
        mindMapView.contentSize = CGSize(width:screenRect.size.width, height: 1000)
        mindMapView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        mindMapView.minimumZoomScale = 0//最小的缩放倍数，默认值为1.0
        mindMapView.maximumZoomScale = 5 //放大的缩放倍数，默认值为1.0
        self.view?.addSubview(mindMapView)
    }
    
    //新建一个树
    func buildNewTree() {
        self.lastOpenKey = nil
        //添加树
        let tree = MindMapTree()
//        tree.addNode(i: 0, element:"B");
//        tree.addNode(i: 0, element:"C");
//        tree.addNode(i: 0, element:"D");
//        tree.addNode(i: 0, element:"E");
//        tree.addNode(i: 0, element:"F");
//        tree.addNode(i: 0, element:"G");
//        tree.addNode(i: 3, element:"H");
//        tree.addNode(i: 4, element:"I");
//        tree.addNode(i: 4, element:"J");
//        tree.addNode(i: 5, element:"K");
//        tree.addNode(i: 5, element:"L");
//        tree.addNode(i: 5, element:"M");
//        tree.addNode(i: 6, element:"N");
//        tree.addNode(i: 9, element:"O");
//        tree.addNode(i: 9, element:"P");
        
        mindMapView.mindMapTree = tree
        mindMapView.drawTree(node: tree.root[0])
    }
    //打开保存的树
    func openSaveTree(key:String) {
        self.lastOpenKey = key
        let saveData = Tool.getUserDefaultDict(key: MINDMAPTREEKEY)[key] as! NSArray
        //添加树
        let tree = MindMapTree(rootNodeArr: saveData)
        mindMapView.mindMapTree = tree
        mindMapView.drawTree(node: tree.root[0])
    }
    
    //MARK:抽屉效果
    @objc func rightBarItemAction() {
        if (self.rightTableView?.isHidden)! {
            self.rightTableView?.isHidden = false
            self.showRightView()
        }else{
            self.rightTableView?.isHidden = true
            self.showMainView()
        }
    }

    
    func showMainView(){
        //动画显示
        UIView.beginAnimations(nil, context: nil)
        
        //屏幕偏移计算
        self.view.center = CGPoint(x: screenRect.width / 2, y: screenRect.height / 2)
        //提交动画
        UIView.commitAnimations()
    }
    
    func showRightView(){
        UIView.beginAnimations(nil, context: nil)
        
        let farmeX = screenRect.width / 2
        let frame:CGRect = CGRect.init(x: farmeX, y: 64, width: screenRect.width - farmeX, height: screenRect.height-64);
        rightTableView?.frame = frame;
        
        UIView.commitAnimations()
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
