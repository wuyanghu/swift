//
//  JigsawCollectionViewController.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/25.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "JigsawCollectionViewCell"

class JigsawCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    var colltionView : UICollectionView?
    var imagePicker:UIImagePickerController!//调用系统图片
    
    var resourceName = [String]()
    
    //MARK:lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "选择图片"
        
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(rightBarItemAction))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        
        resourceName += ["jigsaw1","jigsaw2","jigsaw3","jigsaw4","jigsaw2"]
        
        let layout = UICollectionViewFlowLayout()
        colltionView = UICollectionView(frame: CGRect.init(x: 10, y: 0, width: screenRect.width-20, height: screenRect.height-10), collectionViewLayout: layout)
        //注册一个cell
        colltionView!.register(JigsawCollectionViewCell.self, forCellWithReuseIdentifier:reuseIdentifier)
        colltionView?.delegate = self;
        colltionView?.dataSource = self;
        
        colltionView?.backgroundColor = UIColor.white
        //设置每一个cell的宽高
        layout.itemSize = CGSize.init(width: (screenRect.width-50)/2, height: 250)
        self.view .addSubview(colltionView!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:调用系统图片
    @objc func rightBarItemAction() {
        if self.imagePicker == nil{
            self.imagePicker = UIImagePickerController()
        }
        self.imagePicker.delegate = self
        //设置图片来源为设备图片库
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        self.imagePicker.delegate = nil
        self.dismiss(animated: true, completion: nil)
        
        //从info中取出获取的原始图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let viewController = JigsawMainViewController()
        viewController.open(image: image)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return resourceName.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! JigsawCollectionViewCell
    
        // Configure the cell
        cell.backgroundColor = UIColor.red
        cell.imageView.image = UIImage(named: resourceName[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertVC = UIAlertController(title: "提示", message: "难易度", preferredStyle: UIAlertControllerStyle.actionSheet)
        let easyAlert = UIAlertAction(title: "简单", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            self.jigsawMainClick(type: JigsawType.easy,indexPath: indexPath)
        }
        
        let middleAlert = UIAlertAction(title: "中等", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            self.jigsawMainClick(type: JigsawType.middle,indexPath: indexPath)
        }
        
        let difficultAlert = UIAlertAction(title: "复杂", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            self.jigsawMainClick(type: JigsawType.diffcult,indexPath: indexPath)
        }
        
        let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            print("click Cancel")
        }
        alertVC.addAction(easyAlert)
        alertVC.addAction(middleAlert)
        alertVC.addAction(difficultAlert)
        alertVC.addAction(acCancel)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    
    //MARK:JigsawMain
    func jigsawMainClick(type:JigsawType,indexPath:IndexPath){
        let viewController = JigsawMainViewController()
        viewController.imageName = resourceName[indexPath.item]
        switch type {
        case .easy:
            viewController.nGrid = 3
        case .middle:
            viewController.nGrid = 4
        case .diffcult:
            viewController.nGrid = 5
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
