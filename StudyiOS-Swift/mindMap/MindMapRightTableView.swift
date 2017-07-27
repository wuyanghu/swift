//
//  MindMapRightTableView.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/12.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

enum OptionType:NSInteger {
    case new,open,save,snapshoot,share //默认赋值从0开始，且依次+1
}

typealias mindMapRightTableViewBlock = (_ type: OptionType) -> Void

class MindMapRightTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    
    
    var titleArr:[String]!
    var callBack:mindMapRightTableViewBlock!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.titleArr = ["新建","打开","保存","快照","分享"]
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iderntify:String = "swiftCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: iderntify)
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.default
                , reuseIdentifier: iderntify);
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        cell?.textLabel?.text =  self.titleArr?[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if callBack != nil {
            callBack!(OptionType(rawValue: indexPath.row)!)
        }
    }
}
