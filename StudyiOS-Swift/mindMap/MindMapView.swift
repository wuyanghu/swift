//
//  MindMapView.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/6.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

class MindMapView: UIScrollView,UIScrollViewDelegate,UITextViewDelegate {
    
    class MindNodeModel: NSObject {
        /*
            存储结点的线，textView，button
         */
        
        var lineDict = Dictionary<NSInteger, LineNode>()//线
        var lineTextFieldDict = Dictionary<NSInteger, UITextView>()//文本
        var mindMapTreeNodeDict = Dictionary<NSInteger, MindMapTreeNode>() //记录button的node
        var mindMapTreeNodeButton = Dictionary<NSInteger, UIButton>()//button按钮
        
    }
    
    @available(iOS 9.0, *)
    lazy var verticalView:UIStackView = {
        
        var verticalView = UIStackView()
        verticalView.axis = UILayoutConstraintAxis.vertical
        verticalView.distribution = UIStackViewDistribution.fillEqually;
        verticalView.spacing = 10;
        verticalView.alignment = UIStackViewAlignment.fill;
        
        return verticalView
        
    }();
    
    let topNodePoint = CGPoint(x: 120, y: 20)//根结点
    let elementPoint = CGPoint(x: 20, y: 20)
    let treeNodeWidth = 100 //结点之间的宽度
    let treeNodeHegiht = 50//结点之间的高度
    var nodeY:NSInteger = 10
    var mindMapTree:MindMapTree!
    var mindNodeModel = MindNodeModel()
    var rootElementPoint:MindMapTreeNode!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    //MARK:初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIView.animate(withDuration: 1) { 
            self.drawView()
        }
    }
    
    func drawView() -> Void {
        
        for (_, node) in mindNodeModel.lineDict {
            let startPoint = CGPoint(x: node.startNode.pointPosition.x+elementPoint.x, y: node.startNode.pointPosition.y+elementPoint.y/2)
            let endPoint = CGPoint(x: node.endNode.pointPosition.x, y: node.endNode.pointPosition.y+elementPoint.y/2)
            drawCurve(startPoint: startPoint, endPoint: endPoint)
        }

    }
    
    func printSpace(node:MindMapTreeNode) -> Void {
        /*
            是否在缓存中
         */
        let mindMapTreeNode = mindNodeModel.mindMapTreeNodeDict[node.identification]
        
        var frameX:NSInteger = 0
        
        if mindMapTreeNode == nil {
            frameX = NSInteger(topNodePoint.x)+node.depthNode*treeNodeWidth
            let button = createButton(frame: CGRect.init(x: frameX, y: nodeY, width: NSInteger(elementPoint.x), height: NSInteger(elementPoint.y)), node: node)
            node.pointPosition = CGPoint(x: NSInteger(topNodePoint.x)+node.depthNode*treeNodeWidth, y: nodeY)
            mindNodeModel.mindMapTreeNodeDict[node.identification] = node
            mindNodeModel.mindMapTreeNodeButton[node.identification] = button
            
        }else{
            frameX = NSInteger(topNodePoint.x)+(mindMapTreeNode?.depthNode)!*treeNodeWidth
            
            let button:UIButton = mindNodeModel.mindMapTreeNodeButton[mindMapTreeNode!.identification]!
            button.frame = CGRect.init(x: frameX, y: nodeY, width: NSInteger(elementPoint.x), height: NSInteger(elementPoint.y))
            node.pointPosition = CGPoint(x: NSInteger(topNodePoint.x)+node.depthNode*treeNodeWidth, y: nodeY)
            mindNodeModel.mindMapTreeNodeDict[node.identification] = mindMapTreeNode
        }
        //树的深度
        self.contentSize = CGSize.init(width: NSInteger(topNodePoint.x)+(mindMapTree?.depathMaxNode)!*treeNodeWidth+treeNodeWidth, height: nodeY+treeNodeHegiht)
        
        setNeedsDisplay()
        
        
        if (rootElementPoint != nil) {
            //如果node有父结点
            if rootElementPoint.depthNode >= node.depthNode {
                getParentNode(preNode: rootElementPoint, node: node)
            }else{
                //父结点的深度小于孩子结点，则连线
                print("1-(\(rootElementPoint.element),\(node.element))")
                addLineNode(startNode: rootElementPoint, endNode: node)
            }
        }else{
            //初始化 绘制第一个点的线
            let startNode = MindMapTreeNode()
            startNode.identification = -1
            startNode.pointPosition = CGPoint(x: NSInteger(node.pointPosition.x)-treeNodeWidth, y: NSInteger(node.pointPosition.y))
            addLineNode(startNode: startNode, endNode: node)
        }
        
        if node.firstChild != nil {
            //如果node有孩子结点，记录此结点
            rootElementPoint = node;
        }
        
        if (node.firstChild != nil && node.depthNode<(node.firstChild?.depthNode)!) {
//            print("父节点\(node.element) - 孩子结点\(node.firstChild?.element)")
//            nodeY = 10
        }else{
//            let depthNodeString = mindMapTree.numNodeEveryLevelDict[node.depthNode]
//            let depthNodeInter = NSInteger(depthNodeString!)
            
            //兄弟结点时增加Y
            nodeY+=treeNodeHegiht
        }
        
    }

    //添加一条线的结点
    func addLineNode(startNode:MindMapTreeNode,endNode:MindMapTreeNode) -> Void {
        
        let lineKey = endNode.identification
        let lineNode = mindNodeModel.lineDict[lineKey!]
        if lineNode == nil {
            let lineNode = LineNode()
            lineNode.startNode = startNode
            lineNode.endNode = endNode
            mindNodeModel.lineDict[lineKey!] = lineNode
            
            let frameX = NSInteger(startNode.pointPosition.x+elementPoint.x+10)
            let frame = CGRect.init(x: frameX, y: Int(endNode.pointPosition.y-elementPoint.y-5), width: NSInteger(endNode.pointPosition.x)-frameX, height: 30)
            let textField = createTextField(frame: frame,node: endNode)
            mindNodeModel.lineTextFieldDict[lineKey!] = textField
        }else{
            let textField = mindNodeModel.lineTextFieldDict[lineKey!]
            let frameX = NSInteger((lineNode?.startNode.pointPosition.x)!+elementPoint.x+10)
            let frame = CGRect.init(x: frameX, y: Int((lineNode?.endNode.pointPosition.y)!-elementPoint.y-5), width: NSInteger((lineNode?.endNode.pointPosition.x)!)-frameX, height: 30)
            textField?.frame = frame
            textField?.text = lineNode?.endNode.element
        }
    }
    //递归寻找父节点
    func getParentNode(preNode:MindMapTreeNode,node:MindMapTreeNode) -> Void {
        let tempNode = findPreNode(node: preNode)
        
        if tempNode.identification != -1 {
            if tempNode.depthNode >= node.depthNode{
                getParentNode(preNode: tempNode, node: node)
            }else{
                print("3-(\(tempNode.element),\(node.element))")
                addLineNode(startNode: tempNode, endNode: node)
            }
        }
    }
    
    //寻找上一个node
    func findPreNode(node:MindMapTreeNode) -> MindMapTreeNode {
        let treeNode = MindMapTreeNode()
        treeNode.identification = -1
        
        for (_,tempNode) in mindNodeModel.lineDict {
            if tempNode.endNode.identification == node.identification {
                return tempNode.startNode;
            }
        }
        return treeNode
    }
    
    //MARK:- 创建UI
    
    //画曲线
    func drawCurve(startPoint:CGPoint,endPoint:CGPoint) -> Void {
        let center = CGPoint(x: startPoint.x+0.5, y: endPoint.y-1)
        let curve = CGPoint(x: startPoint.x+10, y: endPoint.y)
        //创建一个贝塞尔路径
        let bezierPath = UIBezierPath()
        //开始绘制
        bezierPath.move(to: startPoint)
        bezierPath.addCurve(to: curve, controlPoint1: center, controlPoint2: center)
        bezierPath.addLine(to: endPoint)
        //使路径闭合，结束绘制
//        bezierPath.close()
        
        //设定颜色，并绘制它们
        UIColor.clear.setFill()
        UIColor.black.setStroke()
        bezierPath.fill()
        bezierPath.stroke()
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
    //画正方形
    func drawRect(frame:CGRect,title:String) -> Void {
        let pathRect = frame.insetBy(dx: 1, dy: 1)
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 15)
        path.lineWidth = 1
        UIColor.green.setFill()
        UIColor.blue.setStroke()
        path.fill()
        path.stroke()
        
        drawText(rect: frame,str: title)
    }
    
    //绘制文字
    func drawText(rect:CGRect,str:String){

        let font = UIFont.systemFont(ofSize: 16)
        let color = UIColor.red
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        (str as NSString).draw(in: rect, withAttributes: [NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:style])
        
    }

    
    func drawTree(node:MindMapTreeNode) -> Void {
        
        printSpace(node: node)
//        print("\(node.element)",terminator: " ")
        if (node.firstChild != nil) {
            drawTree(node: node.firstChild!)
        }
        if (node.nextSibling != nil) {
            drawTree(node: node.nextSibling!)
        }
    }
    
    func createTextField(frame:CGRect,node:MindMapTreeNode) -> UITextView {
        let textField:UITextView = UITextView(frame: frame)
        textField.delegate = self
        textField.textAlignment = NSTextAlignment.left
        textField.returnKeyType = UIReturnKeyType.done
        textField.tag = node.identification
        textField.text = node.element
        self.addSubview(textField)
        
        return textField
    }
    
    func createButton(frame:CGRect,node:MindMapTreeNode) -> UIButton {
        let button:UIButton = UIButton(type:.contactAdd)
        //设置按钮位置和大小
        button.frame = frame
        //设置按钮文字
        button.setTitle(node.element, for:.normal)
        button.tag = node.identification
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action:#selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        
        //button长按事件
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target: self, action:#selector(longpressClick(sender:)))
        longpressGesutre.minimumPressDuration = 0.5//长按时间为1秒
        longpressGesutre.allowableMovement = 15//允许15秒运动
        longpressGesutre.numberOfTouchesRequired = 1//所需触摸1次
        button.addGestureRecognizer(longpressGesutre)
        
        self.addSubview(button)
        
        return button
    }
    /*
     长按删除
     1.删除结点的线、文本、button、button的node
     2.移除结点
     */
    func longpressClick(sender:UITapGestureRecognizer?){
        if sender?.state == .began {
            let button = sender?.view as! UIButton
            let node = mindNodeModel.mindMapTreeNodeDict[button.tag]
            let nodeArr = mindMapTree.removeBoyNode(node: node!)
            //删除其子结点
            for tempNode in nodeArr {
                mindNodeModel.lineDict.removeValue(forKey: (tempNode.identification)!)
                mindNodeModel.mindMapTreeNodeDict.removeValue(forKey: (tempNode.identification)!)
                mindNodeModel.lineTextFieldDict.removeValue(forKey: (tempNode.identification)!)?.removeFromSuperview()
                mindNodeModel.mindMapTreeNodeButton.removeValue(forKey: (tempNode.identification)!)?.removeFromSuperview()
            }
            setNeedsDisplay()
        }
        
    }
    
    func btnClick(sender:UIButton?){
        print("点击了Button\(String(describing: sender?.tag))");
        nodeY = 10
        mindMapTree.addNode(i: (sender?.tag)!, element: "")
        drawTree(node: mindMapTree.root[0])
    }
    
    //MARK:-UITextViewDelegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let node = mindMapTree.findIndexNode(ident: textView.tag)
        node.element = textView.text
    }
    
    //MARK:-UISCrollView
    
    //开始缩放的时候调用
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//        print("scrollViewWillBeginZooming")
//        setNeedsLayout()
    }
    
    //正在缩放的时候调用
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("scrollViewDidZoom")
    }
    
    //缩放完毕的时候调用
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        print("scrollViewDidEndZooming")
//        setNeedsDisplay()
    }
    
    // 1、已经开始滚动（不管是拖、拉、放大、缩小等导致）都会执行此函数
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll")
        setNeedsDisplay()
    }
    // 2、将要开始拖拽，手指已经放在view上并准备拖动的那一刻
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("scrollViewWillBeginDragging")
//        setNeedsDisplay()
    }
    
    // 4、已经结束拖拽，手指刚离开view的那一刻
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("scrollViewDidEndDragging")
//        setNeedsDisplay()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print("scrollViewWillEndDragging")
//        setNeedsDisplay()
    }
    
}
