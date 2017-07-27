//
//  UnLockView.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/25.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit
/*
    1.解决格子之间的空隙问题
    2.touchesMoved解决重复问题
 */

typealias UnLockViewBlock = () -> Void

class UnLockView: UIView {

    var block:UnLockViewBlock!
    
    let gridOrigin = CGPoint(x: 100, y: 200)
    let gridSize = CGSize(width: 30, height: 30)
    let gridSpace:CGFloat = 10
    let nGrid = 3
    
    var moveRow = -1
    var moveCol = -1
    
    var movePointArr:[CGPoint] = [CGPoint]()
    var tempMovePointArr:[CGPoint] = [CGPoint]()
    var tishiLabel:UILabel!
    var count:Int = -1//没有输入密码时
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createGrid()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        for i in 0..<movePointArr.count {
            if i+1<movePointArr.count {
                drawLine(startPoint: movePointArr[i], endPoint: movePointArr[i+1])
                if i == 0 {
                    drawArc(centerPoint: movePointArr[0])
                }
                drawArc(centerPoint: movePointArr[i+1])
                
            }
        }
        
    }

    func createGrid() {
        
        let frameWidth = gridSize.width*CGFloat(nGrid+3)
        let frameX = (screenRect.width - frameWidth)/2
        tishiLabel = createLabel(frame: CGRect.init(x: frameX, y: gridOrigin.y-40, width: frameWidth, height: gridSize.height))
        tishiLabel.layer.borderWidth = 0;
        tishiLabel.numberOfLines = 0
        tishiLabel.textAlignment = NSTextAlignment.center
        self.addSubview(tishiLabel)
        let isPassWord = Tool.getUserDefaultArr(key: UNLOCKFIRSTPASSWORD)
        if isPassWord.isEmpty {
            tishiLabel.text = "请设置密码"
            count = 0
        }else{
            tishiLabel.text = "请输入密码"
        }
        
        // Drawing code
        for row in 0..<nGrid {
            for col in 0..<nGrid {
                let label = createLabel(frame: CGRect.init(origin: turnPoint(row: row, col: col), size: gridSize))
                self.addSubview(label)
            }
        }
    }
    
    func createLabel(frame:CGRect) -> UILabel {
        let label = UILabel.init(frame: frame)
        label.backgroundColor = UIColor.clear
        label.layer.cornerRadius = 5;
        label.layer.borderWidth = 1;
        return label
    }
    
    //计算位置格子点
    func turnPoint(row:Int,col:Int) -> CGPoint {
        let point = CGPoint(x: gridOrigin.x + CGFloat(col)*(gridSize.width+gridSpace), y: gridOrigin.y + CGFloat(row)*(gridSize.height+gridSpace))
        return point
    }
    //计算位置线的点
    func turnLinePoint(moveRow:Int,moveCol:Int) -> CGPoint {
        let movePoint = CGPoint(x: gridOrigin.x+gridSize.width/2 + CGFloat(moveCol)*(gridSize.width+gridSpace), y: gridOrigin.y+gridSize.height/2 + CGFloat(moveRow)*(gridSize.height+gridSpace))
        return movePoint
    }
    
    //得到行数
    func getCol(clickPoint:CGPoint) -> Int {
        let col = NSInteger((clickPoint.x-gridOrigin.x)/(gridSize.width+gridSpace))
        let xMin = gridOrigin.x+(gridSize.width+gridSpace)*CGFloat(col)
        let xMax = xMin+gridSize.width
        
        if clickPoint.x>xMin && clickPoint.x<xMax {
            return col
        }
        return -1
    }
    //得到列数
    func getRow(clickPoint:CGPoint) -> Int {
        let row = NSInteger((clickPoint.y-gridOrigin.y)/(gridSize.height+gridSpace))
        let yMin = gridOrigin.y+(gridSize.height+gridSpace)*CGFloat(row)
        let yMax = yMin+gridSize.height
        if clickPoint.y>yMin && clickPoint.y<yMax {
            return row
        }
        return -1
    }
    
    func isTrueSetPassword(firstArr:[CGPoint],secondArr:[CGPoint]) -> Bool {
        if firstArr.count != secondArr.count {
            return false
        }
        for i in 0..<firstArr.count{
            let firstPoint = firstArr[i];
            let secondPoint = secondArr[i];
            if firstPoint.x != secondPoint.x || firstPoint.y != secondPoint.y {
                return false
            }
        }
        return true
    }
    
    //MARK:-触摸事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        let clickPoint = touch.location(in:self)     //获取当前点击位置
        
        let moveRow = getRow(clickPoint: clickPoint)
        let moveCol = getCol(clickPoint: clickPoint)
        
        if ((moveRow<nGrid && moveRow>=0) && (moveCol<nGrid && moveCol>=0)){
            if !(self.moveCol == moveCol && self.moveRow == moveRow) {
                self.moveCol = moveCol
                self.moveRow = moveRow
                movePointArr.append(turnLinePoint(moveRow: moveRow, moveCol: moveCol))
                setNeedsDisplay()
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if movePointArr.count == 0 {
            return;
        }
        if count == 0 {
            //需要设置密码
            count += 1
            tishiLabel.text = "请再输入一次"
            tempMovePointArr = movePointArr;
        }else if count == 1{
            //需要确认密码
            if isTrueSetPassword(firstArr: tempMovePointArr, secondArr: movePointArr) {
                count += 1
                tishiLabel.text = "密码设置完成"
                
                Tool.saveUerDefault(key: UNLOCKFIRSTPASSWORD, value: movePointArr as AnyObject)
                
                block()
                
            }else{
                //重新设置密码
                count = 0;
                tishiLabel.text = "密码错误,请重新输入..."
            }
            tempMovePointArr.removeAll()
        }else if count == -1 {
            //已经设置过密码
            let isPassWord = Tool.getUserDefaultArr(key: UNLOCKFIRSTPASSWORD)
            if isTrueSetPassword(firstArr: isPassWord as! [CGPoint], secondArr: movePointArr) {
                block()
            }else{
                tishiLabel.text = "密码错误,请重新输入..."
            }
        }
        movePointArr.removeAll()
        self.moveCol = -1
        self.moveRow = -1
        setNeedsDisplay()
        
    }
    
    //MARK:绘图
    //画线
    func drawLine(startPoint:CGPoint,endPoint:CGPoint) -> Void {
        //获取画笔上下文
        let context:CGContext =  UIGraphicsGetCurrentContext()!
        context.setAllowsAntialiasing(true) //抗锯齿设置
        //绘制直线
        context.setStrokeColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1 );//设置画笔颜色方法一
        context.setLineWidth(2);//线条宽度
        context.move(to: startPoint)//开始点位置
        context.addLine(to: endPoint)//结束点位置
        context.strokePath();
        
    }
    
    func drawArc(centerPoint:CGPoint) -> Void {
        
        let radius = CGFloat(2.5)//半径
        
        let startAngle = -CGFloat.init(Double.pi); //
        let endAngle = CGFloat.init(Double.pi) ;
        
        //创建一个画布
        let context = UIGraphicsGetCurrentContext()
        
        context!.setStrokeColor(UIColor.black.cgColor)//画笔颜色
        UIColor.black.setFill()
        context!.setLineWidth(1)//画笔宽度
        context?.addArc(center: centerPoint,radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.closePath()
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
    }
}
