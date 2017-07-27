//
//  ViewController.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/3.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView!
    var dataArr = [
        ["五子棋","思维导图","拼图","数独"],
        ["左滑抽屉效果","获取系统图片资源","九宫格解锁"]]
    
    //MARK:生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "功能列表"
//        _ = BluetoothShareInstance.shared
        // Do any additional setup after loading the view, typically from a nib.
        let tableviewFrame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.createTableView()
        
        let unLockView = UnLockView(frame: tableviewFrame)
        unLockView.block = { () in
            unLockView.removeFromSuperview()
        }
        unLockView.backgroundColor = UIColor.white
        self.view.addSubview(unLockView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK:UITableView
    
    func createTableView() {
        self.tableView = UITableView.init(frame:CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableViewStyle.plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr[section].count
    }

    //创建各单元格显示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iderntify:String = "swiftCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: iderntify)
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.default
                , reuseIdentifier: iderntify);
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        cell?.textLabel?.text =  dataArr[indexPath.section][indexPath.row]
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: true)
        var viewController:UIViewController!;
        if indexPath.section == 0 {
            if indexPath.row == 0{
                //实例化一个将要跳转的viewController
                viewController = DrawLineViewController()
            }else if indexPath.row == 1{
                viewController = MindMapViewController()
            }else if indexPath.row == 2{
                viewController = JigsawCollectionViewController()
            }else if indexPath.row == 3{
                viewController = SudokuMainViewController()
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0{
                viewController = DrawerViewController()
            }else if indexPath.row == 1{
                viewController = JigsawImageViewController()
            }
        }
        
        if (viewController != nil) {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if section == 0 {
            return "小程序"
        }
        return "辅助小功能"
    }
}

