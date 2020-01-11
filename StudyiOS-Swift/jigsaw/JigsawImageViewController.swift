//
//  JigsawImageViewController.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/25.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

class JigsawImageViewController: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    var imagePicker:UIImagePickerController!
    var imageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "获取系统图片资源"
        
        imageView = UIImageView.init(frame: self.view.bounds)
        self.view.addSubview(imageView)
        
        
        let button = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 40, height: 30))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action:#selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func buttonClick(sender:UIButton) {
        if self.imagePicker == nil{
            self.imagePicker = UIImagePickerController()
        }
        self.imagePicker.delegate = self
        //设置图片来源为设备图片库
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func photo() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            if self.imagePicker == nil{
                self.imagePicker = UIImagePickerController()
            }
            self.imagePicker.delegate = self
            //设置图片来源为相机
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }else{
            //弹出警告框
            let errorAlert = UIAlertController(title: "相机不可用", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil)
            errorAlert.addAction(cancelAction)
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        //从info中取出获取的原始图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = image
        //设置图片显示模式
        self.imageView.contentMode = .scaleAspectFill
        self.imagePicker.delegate = nil
        self.dismiss(animated: true, completion: nil)
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
