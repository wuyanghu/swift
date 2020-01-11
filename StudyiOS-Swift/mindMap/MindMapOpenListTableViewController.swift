//
//  MindMapOpenListTableViewController.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/13.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

typealias MindMapOpenListTableViewControllerBlock = (_ key: String) -> Void

class MindMapOpenListTableViewController: UITableViewController {
    
    var openListBlock:MindMapOpenListTableViewControllerBlock!
    let mindMapDict = Tool.getUserDefaultDict(key: MINDMAPTREEKEY)
    lazy var mindMapKeyArray:Array = { () -> [Any] in
        let mindMapKeys = self.mindMapDict.allKeys
        return mindMapKeys
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择导图"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mindMapKeyArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iderntify:String = "swiftCell\(indexPath.row)"
        var cell = tableView.dequeueReusableCell(withIdentifier: iderntify)
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.default
                , reuseIdentifier: iderntify);
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            let longpressGesutre = UILongPressGestureRecognizer(target: self, action:#selector(longpressClick(sender:)))
            longpressGesutre.minimumPressDuration = 1//长按时间为1秒
            longpressGesutre.allowableMovement = 15//允许15秒运动
            longpressGesutre.numberOfTouchesRequired = 1//所需触摸1次
            cell?.addGestureRecognizer(longpressGesutre)
        }
        
        cell?.textLabel?.text =  mindMapKeyArray[indexPath.row] as? String
        return cell!
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: true)
        
        let keyStr = mindMapKeyArray[indexPath.row]
        openListBlock(keyStr as! String)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            mindMapDict.removeObject(forKey: mindMapKeyArray[indexPath.row])
            Tool.saveUerDefault(key: MINDMAPTREEKEY, value: mindMapDict)
            
            mindMapKeyArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    @objc func longpressClick(sender:UITapGestureRecognizer?){
        if sender?.state == .began {
            let cell = sender?.view as! UITableViewCell
            print("长按\(String(describing: cell.textLabel?.text))");
            
            let alertVC = UIAlertController(title: "重命名", message: nil, preferredStyle: .alert)
            let cellLabletext = cell.textLabel?.text
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
                (action: UIAlertAction) -> Void in
                let loginField = (alertVC.textFields?.first)! as UITextField
                
                if (Tool.isEmptyStr(str: loginField.text!)) {
                    //判断输入不能为空
                    let alertView = UIAlertView(title: "提示", message: "名称不能为空，请重新输入", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }else if((self.mindMapDict[loginField.text ?? ""]) != nil){
                    let alertView = UIAlertView(title: "提示", message: "文件已存在，请重新命名", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }else{
                    let saveValue = self.mindMapDict[cellLabletext ?? ""]//保存原来的值
                    self.mindMapDict.removeObject(forKey: cellLabletext ?? "")//移除原来的值
                    
                    cell.textLabel?.text = loginField.text
                    
                    self.mindMapDict[loginField.text ?? ""] = saveValue//重新保存值
                    Tool.saveUerDefault(key: MINDMAPTREEKEY, value: self.mindMapDict)//持久化
                }
                
                
            })
            
            alertVC.addTextField {
                (textField: UITextField!) -> Void in
                textField.placeholder = "输入导图名称"
            }
            
            alertVC.addAction(okAction)
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
