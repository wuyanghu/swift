//
//  Tool.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/13.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit


class Tool: NSObject {
    
    //动态计算高度
    static func getLabHeight(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize.init(width: width, height: CGFloat(MAXFLOAT))
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.height
    }
    
    //剔除空格后判断字符是否为空
    static func isEmptyStr(str:String) -> Bool{
        let string = str.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if string.isEmpty {
            return true
        }
        return false
    }
    
    //MARK: 日期操作
    static func getNowDate(formatDate:String) -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current //设置时区，时间为当前系统时间
        dateFormatter.dateFormat = formatDate
        let stringDate = dateFormatter.string(from: currentDate)
        return stringDate
    }
    
    //MARK:保存数据
    //保存时可以为Object,取出时按所需类型
    static func saveUerDefault(key:String,value:AnyObject) -> Void {
        let userDefaults = UserDefaults.standard
        let modelData:NSData = NSKeyedArchiver.archivedData(withRootObject: value) as NSData
        userDefaults.set(modelData, forKey: key)
        userDefaults.synchronize()
    }
    
    //取出字典类型
    static func getUserDefaultDict(key:String) -> NSMutableDictionary {
        let userDefaults = UserDefaults.standard
        let value = userDefaults.object(forKey: key)
        
        var obj:NSMutableDictionary? = NSMutableDictionary.init()
        if value != nil {
            obj = NSKeyedUnarchiver.unarchiveObject(with: value as! Data) as? NSMutableDictionary
        }
        
        return obj!
    }
    //取出字符类型
    static func getUserDefaultValue(key:String) -> String {
        let userDefaults = UserDefaults.standard
        let value = userDefaults.object(forKey: key)
        var obj = ""
        if value != nil {
            obj = NSKeyedUnarchiver.unarchiveObject(with: value as! Data) as! String
        }
        return obj
        
    }
    
    //取出字符类型
    static func getUserDefaultArr(key:String) -> Array<Any> {
        let userDefaults = UserDefaults.standard
        let value = userDefaults.object(forKey: key)
        var obj:NSArray = NSArray.init()
        if value != nil {
            obj = NSKeyedUnarchiver.unarchiveObject(with: value as! Data) as! NSArray
        }
        return obj as! Array<Any>
        
    }
    
    //plist文件存取
    static func getPlist(finishCallBack:@escaping (_ result: AnyObject)->()){
    
        let filePath:String = NSHomeDirectory() + "/Documents/address.plist"
        if (FileManager.default.fileExists(atPath: filePath))  {
            let contentData:NSData = try! NSData.init(contentsOfFile: filePath)
            let contentA:NSArray = NSKeyedUnarchiver.unarchiveObject(with: contentData as Data) as! NSArray
            
            finishCallBack(contentA as AnyObject)
        }
    }
    
    static func savePliat(array: NSArray){
        
        DispatchQueue.global().async {
            let filePath:String = NSHomeDirectory() + "/Documents/address.plist"
            //将NSArray转成NSDATA，然后将NSDATA写入到plist中，具体怎么写的请看下面的代码
            let a:NSData = NSKeyedArchiver.archivedData(withRootObject: array) as NSData
            let fileManager = FileManager.default
            let isLocalDataExisted = fileManager.fileExists(atPath: filePath)
            
            if !isLocalDataExisted {
                fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
            }
            
            let b =  a.write(toFile: filePath, atomically: true)
            
            print(b)
            
        }
        
    }
}
