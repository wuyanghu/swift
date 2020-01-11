//
//  MindMapTree.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/11.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

/*
    树形结构
 */
class MindMapTree: NSObject {
    //MARK:属性
    var root:[MindMapTreeNode] = [MindMapTreeNode]();
    var depathMaxNode = 0//树的深度
    var widthMaxNode = 0//树的宽度
    var numNodeEveryLevelDict = Dictionary<NSInteger, String>()//每层的结点
    var parentNode:MindMapTreeNode!//
    var delNodeArr:[MindMapTreeNode] = [MindMapTreeNode]()
    var identificationNode:Int = 0//标识结点，确定唯一性。累加
    //MARK: 方法 初始化
    override init() {
        super.init()
        //初始化父节点
        let treeNode = MindMapTreeNode()
        treeNode.element = "A"
        treeNode.firstChild = nil
        treeNode.nextSibling = nil
        treeNode.identification = identificationNode
        root.append(treeNode)
        
    }
    
    //MARK: 方法 初始化 - 适合保存过的
    init(rootNodeArr:NSArray) {
        super.init()
        //初始化父节点
        root = rootNodeArr as! [MindMapTreeNode]
        identificationNode = (root.last?.identification)!
        
        calHeightAndWidthTree()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 添加结点
    //添加结点
    func addNode(i:NSInteger,element:String) -> Void {
        let parent:MindMapTreeNode = findIndexNode(ident: i)
        
        let treeNode = MindMapTreeNode()
        treeNode.element = element
        treeNode.firstChild = nil
        treeNode.nextSibling = nil
        identificationNode += 1
        treeNode.identification = identificationNode
        root.append(treeNode)
        
        if parent.firstChild == nil {
            parent.firstChild = treeNode
        }else{
            addBrotherNode(bro: parent.firstChild!, node: treeNode);
        }
        
        calHeightAndWidthTree()
    }
    
    func addBrotherNode(bro:MindMapTreeNode,node:MindMapTreeNode) -> Void {
        if bro.nextSibling == nil {
            bro.nextSibling = node
        }else{
            addBrotherNode(bro: bro.nextSibling!, node: node)
        }
    }
    
    //删除结点及其子结点
    func removeNode(node:MindMapTreeNode) -> [MindMapTreeNode] {
        delNodeArr.removeAll()//保证每次都是最新的
        //记录需要删除的结点
        preOrder(parent: node)
        if node.nextSibling != nil {
            preOrderNextSibling(parent:node.nextSibling!)
        }
        /*
            1.遍历自己的这棵树
                如果有兄弟结点，则把兄弟结点放上一个结点
                记下自己和孩子结点
            2.获取父结点，从父结点开始遍历，删除这个节点
            3.在root统一中删除
         */
        let nextSibingNode = node.nextSibling//保存要删除的兄弟结点
        
        getPreSiblingNode(parent: root[0], node: node)
        if parentNode.nextSibling?.identification == node.identification {
            //说明找到的是兄弟结点
            //删除原来的结点及子结点，把原来的兄弟结点的兄弟结点接上
            parentNode.nextSibling = nextSibingNode
            //记住node及其子结点，并删除
        }else if parentNode.firstChild?.identification == node.identification {
            parentNode.firstChild = nextSibingNode
        }
        
        //从内存中删除相应的结点
        for node in delNodeArr {
            root.remove(at: root.index(of: node)!)
        }
        
        calHeightAndWidthTree()
        
        return delNodeArr
    }
    
    //删除子结点
    func removeBoyNode(node:MindMapTreeNode) -> [MindMapTreeNode] {
        delNodeArr.removeAll()//保证每次都是最新的
        //记录需要删除的结点
        preOrder(parent: node)
        if node.nextSibling != nil {
            preOrderNextSibling(parent:node.nextSibling!)
        }
        if node.firstChild != nil {
            node.firstChild = nil
        }
        delNodeArr.remove(at: delNodeArr.index(of: node)!)
        
        for delNode in delNodeArr {
            let delIndex = root.index(of: delNode)
            if (delIndex != nil) {
                root.remove(at: delIndex!)
            }
        }
        
        calHeightAndWidthTree()
        
        return delNodeArr
    }
    
    //按唯一标识查找
    func findIndexNode(ident:Int) -> MindMapTreeNode {
        let errNode = MindMapTreeNode()
        errNode.identification = -1
        for node in root {
            if node.identification == ident {
                return node
            }
        }
        return errNode
    }
    
    //得到上一个兄弟结点或父节点
    func getPreSiblingNode(parent:MindMapTreeNode,node:MindMapTreeNode) -> Void {
        
        if parent.firstChild?.identification == node.identification || parent.nextSibling?.identification == node.identification {
            parentNode = parent
            return
        }
        
        if (parent.firstChild != nil) {
            getPreSiblingNode(parent: parent.firstChild!,node: node)
        }
        if (parent.nextSibling != nil) {
            getPreSiblingNode(parent: parent.nextSibling!,node: node)
        }
    }
    
    func preOrder(parent:MindMapTreeNode) -> Void {
        delNodeArr.append(parent)
        if (parent.firstChild != nil) {
            preOrder(parent: parent.firstChild!)
        }
        if (parent.nextSibling != nil) {
            preOrder(parent: parent.nextSibling!)
        }
    }
    
    func preOrderNextSibling(parent:MindMapTreeNode) -> Void {
        delNodeArr.remove(at: delNodeArr.index(of: parent)!)
        if (parent.firstChild != nil) {
            preOrderNextSibling(parent: parent.firstChild!)
        }
        if (parent.nextSibling != nil) {
            preOrderNextSibling(parent: parent.nextSibling!)
        }
    }
    
    //计算树的高度和宽度
    private func calHeightAndWidthTree() {
        depathMaxNode = 0;
        widthMaxNode = 0;
        numNodeEveryLevelDict.removeAll()
        calDynamicDataTree(node: root.first!, depthNum: 0, widthNum: 1)
    }
    
    //添加或删除结点时，必须重新计算
    //计算树的深度及宽度、结点的深度、每层有多少个结点(动态计算)
    private func calDynamicDataTree(node:MindMapTreeNode,depthNum:NSInteger,widthNum:NSInteger) -> Void {
        //计算树的深度
        if depathMaxNode<depthNum {
            depathMaxNode = depthNum
        }
        
        if widthMaxNode<widthNum {
            widthMaxNode=widthNum
        }
        
        node.depthNode = depthNum//保存结点的深度
        
        let saveNum = numNodeEveryLevelDict[depthNum]
        if saveNum == nil {
            numNodeEveryLevelDict[depthNum] = "1"
        }else{
            numNodeEveryLevelDict[depthNum] = String.init("\(NSInteger(saveNum!)!+1)")
        }
        
        if (node.firstChild != nil) {
            calDynamicDataTree(node: node.firstChild!, depthNum: depthNum+1,widthNum: widthNum)
        }
        if (node.nextSibling != nil) {
            calDynamicDataTree(node: node.nextSibling!, depthNum: depthNum,widthNum: widthNum+1)
        }
    }

}
