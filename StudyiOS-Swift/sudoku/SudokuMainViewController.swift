//
//  JigsawMainViewController.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/21.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

class SudokuMainViewController: UIViewController {
    
    let JIGSATOPY = 64
    var sudokuArr:Array<Array<Int>>!
    
    //MARK:lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "数独"
        let sudo = SudokuModel()
        sudokuArr = sudo.getSudokuArr()
        createGrid(nGrid: 9)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createGrid(nGrid:Int){
        let sqrtNGrid = Int.init(sqrt(Double(nGrid)))
        let width = screenRect.width/CGFloat(nGrid)//格子的边
        
        //绘制数独
        for row in 0..<nGrid {
            for col in 0..<nGrid {
                let model = SudokuModel()
                
                if col+row == nGrid || col*row == nGrid || col-row == 1 {
                    model.isVisible = false
                }else{
                    model.isVisible = true
                }
                
                var frame = CGRect.init(x: CGFloat(col)*width, y: CGFloat(JIGSATOPY*2)+CGFloat(row)*width, width: width-1, height: width-1)
                model.point = CGPoint.init(x: row, y: col)
                model.label = createLabel(frame: frame)
                if model.isVisible {
                    model.label.text = "\(sudokuArr[row][col])"
                }
                self.view.addSubview(model.label)
                
                //画线
                if col%sqrtNGrid == 0 && row%sqrtNGrid == 0{
                    frame.size = CGSize.init(width: width*CGFloat(sqrtNGrid), height: width*CGFloat(sqrtNGrid))
                    let view = createView(frame: frame)
                    self.view.addSubview(view)
                }
            }
        }
        
        //绘制下方点击按钮
        let btnY = JIGSATOPY*2+(nGrid+1) * Int.init(width)
        for i in 0..<nGrid {
            let frame = CGRect.init(x: CGFloat(i)*width, y: CGFloat(btnY), width: width-2, height: width)
            let btn = createButton(frame: frame, title: "\(i)")
            
            self.view.addSubview(btn)
        }
    }
    
    func createView(frame:CGRect) -> UIView {
        let view = UIView.init(frame: frame)
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 1;
        return view
    }
    
    func createLabel(frame:CGRect) -> UILabel {
        let label = UILabel.init(frame: frame)
        label.backgroundColor = UIColor.clear
        label.layer.cornerRadius = 5;
        label.layer.borderWidth = 1;
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func createButton(frame:CGRect,title:String) -> UIButton {
        let button = UIButton.init(frame: frame)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.tag = Int(title)!
        button.setTitle(title, for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action:#selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }
    
    func btnClick(sender:UIButton?){
        print("点击了Button\(String(describing: sender?.tag))");
    }
    
    //图片显示的frame
    func getPositionFrame(index:Int,nGrid:Int) -> CGRect {
        let row = index/nGrid
        let col = index%nGrid
        
        let width = screenRect.width/CGFloat(nGrid)
        let height = (screenRect.height-CGFloat(JIGSATOPY)*2)/CGFloat(nGrid)
        
        return CGRect.init(x: CGFloat(col)*width, y: CGFloat(JIGSATOPY)+CGFloat(row)*height, width: width, height: height)
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
