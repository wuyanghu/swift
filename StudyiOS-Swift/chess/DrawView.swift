//
//  DrawView.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/3.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

protocol DrawViewDelegate {
    func chessEnd(message:String)
}

class DrawView: UIView {
    enum orientationChessType{
        case left,right,top,bottom,leftTop,leftBottom,rightTop,rightBottom
    };
    //代理，回调
    var delegate: DrawViewDelegate!
    //获取屏幕大小（不包括状态栏高度）
    
    var playChess:NSInteger = 0
    
    static let rowSpace = 20//行高
    static let colSpace = 20//列宽
    static let rowAll = 13;//总共有多少行
    static let colAll = 13;//总共有多少列
    static let startX = 15;
    static let startY = 25;
    static let chessboardHeight = CGFloat.init(rowSpace*rowAll)+CGFloat(startY)
    static let chessboardWidth = CGFloat.init(colSpace*colAll)+CGFloat(startX)
    
    var recordTouchCoordArray:[ChessModel] = [ChessModel]();//记录坐标的位置
    
    //MARK:初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:绘制图形
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //画横线
        for i in 0...DrawView.rowAll {
            drawLine(startPoint: CGPoint.init(x: DrawView.startX, y: DrawView.startY+DrawView.rowSpace*i), endPoint: CGPoint.init(x: DrawView.chessboardWidth, y: CGFloat(DrawView.startY+DrawView.rowSpace*i)))
        }
        
        //画竖线
        for j in 0...DrawView.colAll {
            drawLine(startPoint: CGPoint.init(x: DrawView.startX+DrawView.rowSpace*j, y: DrawView.startY), endPoint: CGPoint.init(x: CGFloat(DrawView.startX+DrawView.rowSpace*j), y: DrawView.chessboardHeight))
        }
        
        for chessModel in recordTouchCoordArray{
            drawArc(chessModel: chessModel)
        }
    }
    
    
    func drawArc(chessModel:ChessModel) -> Void {
        
        let centerPoint = chessModel.point
        
        let radius = CGFloat(DrawView.rowSpace/2)//半径
        
        let startAngle = -CGFloat.init(Double.pi); //
        let endAngle = CGFloat.init(Double.pi) ;
        
        //创建一个画布
        let context = UIGraphicsGetCurrentContext()
        
        if chessModel.playChess == 0 {
            context!.setStrokeColor(UIColor.black.cgColor)//画笔颜色
            UIColor.black.setFill()
        }else if chessModel.playChess == 1{
            context!.setStrokeColor(UIColor.white.cgColor)//画笔颜色
            UIColor.white.setFill()
        }
        context!.setLineWidth(1)//画笔宽度
        context?.addArc(center: centerPoint!,radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.closePath()
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
    }
    
    //画线
    func drawLine(startPoint:CGPoint,endPoint:CGPoint) -> Void {
        //获取画笔上下文
        let context:CGContext =  UIGraphicsGetCurrentContext()!
        context.setAllowsAntialiasing(true) //抗锯齿设置
        //绘制直线
        context.setStrokeColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1 );//设置画笔颜色方法一
        context.setLineWidth(1);//线条宽度
        context.move(to: startPoint)//开始点位置
        context.addLine(to: endPoint)//结束点位置
        context.strokePath();
        
    }
    
    //MARK:判断常用的合法性
    //判断点击的坐标是否在范围内
    func isPointInChess(clickPoint:CGPoint) -> Bool {
        if (clickPoint.x>=CGFloat(DrawView.startX-DrawView.colSpace/2) && clickPoint.x<DrawView.chessboardWidth+CGFloat(DrawView.colSpace) && (clickPoint.y>=CGFloat(DrawView.startY-DrawView.colSpace/2) && clickPoint.y<DrawView.chessboardHeight+CGFloat(DrawView.colSpace))){
            return true
        }
        print("点击坐标超过棋盘范围")
        return false
    }
    
    //判断，如果该棋子在棋盘上是否存在
    func isPointExist(point:CGPoint) -> Bool {
        for chessModel in recordTouchCoordArray {
            let tempPoint = chessModel.point
            if tempPoint?.x==point.x && tempPoint?.y==point.y {
//                print("该棋子已经存在")
                return true
            }
        }
        return false
    }
    //判断，如果该棋子是否存在，存在是哪一方
    func isPointExistWhich(clickChessModel:ChessModel) -> Bool {
        
        for chessModel in recordTouchCoordArray {
            let tempPoint = chessModel.point
            if tempPoint?.x == clickChessModel.point.x && tempPoint?.y == clickChessModel.point.y && chessModel.playChess == clickChessModel.playChess{
                return true
            }
        }
        return false
    }
    
    
    //MARK:判断棋盘是否结束
    func isEndChess(chessModel:ChessModel) -> Bool {
        //一共要往4个方向判断  横向 竖向  斜角有两种  算法大概是这样的按下棋子的瞬间那个点开始算， 遍历到有棋子的地方在往反方向遍历 找到数量等于5就赢
        
        let countLeftSequence = countRecursive(chessModel: chessModel,orientation: orientationChessType.left)
        let countRightSequence = countRecursive(chessModel: chessModel,orientation: orientationChessType.right)
        if countLeftSequence+countRightSequence == 4 {
            return true
        }
        
        let countTopSequence = countRecursive(chessModel: chessModel,orientation: orientationChessType.top)
        let countBottomSequence = countRecursive(chessModel: chessModel,orientation: orientationChessType.bottom)
        if countTopSequence+countBottomSequence == 4 {
            return true
        }
        
        let countLeftTopSequence = countRecursive(chessModel: chessModel,orientation: orientationChessType.leftTop)
        let countRightBottomSequence = countRecursive(chessModel: chessModel,orientation: orientationChessType.rightBottom)
        if countLeftTopSequence+countRightBottomSequence == 4 {
            return true
        }
        
        let countLeftBottomSequence = countRecursive(chessModel: chessModel,orientation: orientationChessType.leftBottom)
        let countRightTopSequence = countRecursive(chessModel: chessModel,orientation: orientationChessType.rightTop)
        if countLeftBottomSequence+countRightTopSequence == 4 {
            return true
        }
        return false
    }
    
    //坐标的点
    func countRecursive(chessModel:ChessModel,orientation:orientationChessType) -> NSInteger {
        let left = NSInteger(chessModel.point.x)-DrawView.colSpace
        let right = NSInteger(chessModel.point.x)+DrawView.colSpace
        let top = NSInteger(chessModel.point.y)-DrawView.rowSpace
        let bottom = NSInteger(chessModel.point.y)+DrawView.rowSpace
        
        var clickPoint:CGPoint;
        switch orientation {
        case .left:
            clickPoint = CGPoint(x: left, y: NSInteger(chessModel.point.y))
        case .right:
            clickPoint = CGPoint(x: right, y: NSInteger(chessModel.point.y))
        case .top:
            clickPoint = CGPoint(x: NSInteger(chessModel.point.x), y: top)
        case .bottom:
            clickPoint = CGPoint(x: NSInteger(chessModel.point.x), y: bottom)
        case .leftTop:
            clickPoint = CGPoint(x: left, y: top)
        case .leftBottom:
            clickPoint = CGPoint(x: left, y: bottom)
        case .rightTop:
            clickPoint = CGPoint(x: right, y: top)
        case .rightBottom:
            clickPoint = CGPoint(x: right, y: bottom)
        }

        let tempModel = ChessModel()
        tempModel.point = clickPoint
        tempModel.playChess = chessModel.playChess
        
        if isPointExistWhich(clickChessModel: tempModel){
            return countRecursive(chessModel: tempModel,orientation: orientation)+1
        }
        return 0
    }
    
    //MARK:-OTHER
    
    //清楚数据，重新开始
    func clickData() -> Void {
        playChess = 0
        recordTouchCoordArray.removeAll()
        setNeedsDisplay()
    }
    
    //把点击的点转换成棋盘的点
    func pointTurn(clickPoint:CGPoint) -> CGPoint {
        //数据转换
        let clickRow = getRowChess(point: clickPoint)
        let clickCol = getColChess(point: clickPoint)
        
        let currentPointX = DrawView.startX+DrawView.rowSpace*clickRow
        let currentPointY = DrawView.startY+DrawView.colSpace*clickCol
        let currentPoint = CGPoint(x:currentPointX, y: currentPointY)
        return currentPoint;
    }
    
    func getColChess(point:CGPoint) -> NSInteger {
        let colChess = NSInteger((point.y+CGFloat(DrawView.rowSpace/2)-CGFloat(DrawView.startY))/CGFloat(DrawView.rowSpace))
        
        return colChess
    }
    
    func getRowChess(point:CGPoint) -> NSInteger {
        let rowChess = NSInteger((point.x+CGFloat(DrawView.colSpace/2)-CGFloat(DrawView.startX))/CGFloat(DrawView.colSpace))
        
        return rowChess
    }
    
    //MARK:-触摸事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        let clickPoint = touch.location(in:self)     //获取当前点击位置
        let currentPoint = pointTurn(clickPoint: clickPoint)
        if isPointInChess(clickPoint: currentPoint) {
            
            if !isPointExist(point: currentPoint) {
                let chessModel = ChessModel()
                chessModel.point = currentPoint
                chessModel.playChess = playChess % 2
                
                if isEndChess(chessModel: chessModel) {
                    var message = "白方胜"
                    if (chessModel.playChess==0){
                        message = "黑方胜"
                    }                    
                    delegate.chessEnd(message: message)
                }
                
                recordTouchCoordArray.append(chessModel)
                
                playChess = playChess + 1
            }
            
            setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    
    
}
