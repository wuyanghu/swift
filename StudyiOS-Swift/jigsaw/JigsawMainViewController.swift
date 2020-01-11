//
//  JigsawMainViewController.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/21.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

class JigsawMainViewController: UIViewController {
    
    let JIGSATOPY = 64
    var nGrid:Int = 3
    
    var gridWidth:CGFloat!//格子的宽度
    var gridHeight:CGFloat!//格子的高度
    
    var startRow:Int = -1
    var startCol:Int = -1
    
    var imageViewArr:[JigsawModel]!
    var imageName = "jigsaw1"
    //MARK:lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拼图"
        // Do any additional setup after loading the view.
        if imageViewArr == nil {
            imageViewArr = cuttingImage(image: UIImage(named: imageName)!)
        }
        for jigsawModel in imageViewArr {
            self.view.addSubview(jigsawModel.imageView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:其他方法
    
    func open(image:UIImage) {
        imageViewArr = cuttingImage(image: image)
    }
    
    //将数组乱序
    func shuffle(list:Array<Any>) -> Array<Any> {
        var sortList = list
        for index in 0..<sortList.count {
            let newIndex = Int(arc4random_uniform(UInt32(sortList.count-index))) + index
            if index != newIndex {
                sortList.swapAt(index, newIndex)
            }
        }
        return sortList
    }
    
    //裁剪图片，成九宫格
    func cuttingImage(image:UIImage) -> [JigsawModel]{
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        //按图片的大小将图片分成n个格子
        let gridImageWidth = imageWidth/CGFloat(nGrid)
        let gridImageHeight = imageHeight/CGFloat(nGrid)
        
        gridWidth = screenRect.width/CGFloat(nGrid)
        gridHeight = (screenRect.height-CGFloat(JIGSATOPY))/CGFloat(nGrid)
        
        var imageArr:[JigsawModel] = [JigsawModel]();//存储切割好的图片
        //切割图片
        for row in 0..<nGrid {
            for col in 0..<nGrid {
                let model = JigsawModel()
                model.ident = row*nGrid+col
                
                let frame = CGRect.init(x: CGFloat(col)*gridImageWidth, y: CGFloat(row)*gridImageHeight, width: gridImageWidth, height: gridImageHeight)//图片需要裁剪的frame
                
                model.index = col*nGrid+row
                model.imageView = UIImageView.init(frame: getPositionFrame(index: model.index))
                model.imageView.image = imageFromImage(image: image, inRect: frame)
                
                if !(row==nGrid-1 && col==nGrid-1) {
                    imageArr.append(model)
                }
            }
        }
        
//        imageArr = shuffle(list: imageArr) as! [JigsawModel]
        
        return imageArr
    }
    
    //裁剪图片
    func imageFromImage(image:UIImage,inRect:CGRect) -> UIImage {
        let sourceImageRef = image.cgImage
        let newImageRef = sourceImageRef!.cropping(to: inRect);
        let newImage = UIImage(cgImage: newImageRef!)
        
        return newImage;
    }

    func isJiGsawComplete() -> Bool {
        var count:Int = 0
        //标识与下标有一个不同，则没有结束
        for model in imageViewArr {
            if model.index == model.ident {
                count+=1
            }
        }
        if count == imageViewArr.count {
            return true
        }
        return false
    }
    
    func findValue(index:Int) -> JigsawModel {
        let tempModel = JigsawModel()
        tempModel.index = -1
        tempModel.ident = -1
        for model in imageViewArr {
            if model.index == index {
                return model
            }
        }
        return tempModel
    }
    
    //图片显示的frame
    func getPositionFrame(index:Int) -> CGRect {
        let row = index/nGrid
        let col = index%nGrid
        return CGRect.init(x: CGFloat(col)*gridWidth, y: CGFloat(JIGSATOPY)+CGFloat(row)*gridHeight, width: gridWidth-2, height: gridHeight-2)
    }
    
    //得到行数
    func getCol(clickPoint:CGPoint) -> Int {
        let col = NSInteger(clickPoint.x/gridWidth)
        return col
    }
    //得到列数
    func getRow(clickPoint:CGPoint) -> Int {
        let row = NSInteger((clickPoint.y-CGFloat(JIGSATOPY))/gridHeight)
        return row
    }

    //MARK:-触摸事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        let clickPoint = touch.location(in:self.view)     //获取当前点击位置
        
        startRow = getRow(clickPoint: clickPoint)
        startCol = getCol(clickPoint: clickPoint)
        print("start-\(startRow),\(startCol)")
    }
    /*
        1.判断拼图是否完成
        2.判断此位置是否可移动
        3.
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        let clickPoint = touch.location(in:self.view)     //获取当前点击位置
        
        let endRow = getRow(clickPoint: clickPoint)
        let endCol = getCol(clickPoint: clickPoint)
        print("end-\(endRow),\(endCol)")
        
        let startIndex = startRow*nGrid+startCol
        let jigsawModel = findValue(index: startIndex)
        if jigsawModel.index == -1 {
            //启点位置有值，不能为空
            return
        }
        let endIndex = endRow*nGrid+endCol
        let endJigsawModel = findValue(index: endIndex)
        if endJigsawModel.index != -1 {
            //结束位置没有值，必须为空才能继续
            return
        }
        
        if endCol == startCol {
            if endRow>startRow {
                print("向下移动")
                jigsawModel.index += nGrid
            }else if endRow<startRow{
                print("向上移动")
                jigsawModel.index -= nGrid
            }
        }else if endRow == startRow{
            if endCol>startCol {
                print("向右移动")
                jigsawModel.index += 1
            }else if endCol<startCol{
                print("向左移动")
                jigsawModel.index -= 1
            }
        }
        jigsawModel.imageView.frame = getPositionFrame(index: jigsawModel.index)
        if isJiGsawComplete() {
            let alert = UIAlertController.init(title: "提示", message: String.init(format: "游戏结束,请重新开始"), preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: {
                (action: UIAlertAction) -> Void in

            }))
            self.present(alert, animated: true, completion: nil)
        }
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
