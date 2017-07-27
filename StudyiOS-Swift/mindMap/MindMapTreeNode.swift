//
//  TreeNode.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/6.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

/*
    树结点的结构
 */
class MindMapTreeNode: NSObject,NSCoding {
    var element:String = "";//该节点的元素
    var identification:NSInteger! //唯一标识，累加
    var firstChild:MindMapTreeNode? = nil//指向该节点的第一个孩子
    var nextSibling:MindMapTreeNode? = nil//指向该节点的兄弟节点
    var pointPosition:CGPoint! //记录该点坐标
    var depthNode:NSInteger = 0 //结点深度
    
    
    override init() {
        super.init()
    }
    
    //swift中使用对象归档进行数据本地
    required init(coder aDecoder: NSCoder)
    {
        super.init()
        self.element=(aDecoder.decodeObject(forKey: "element") as? String)!
        self.identification = (aDecoder.decodeObject(forKey: "identification") as? NSInteger)
        self.firstChild=(aDecoder.decodeObject(forKey: "firstChild") as? MindMapTreeNode)
        self.nextSibling=(aDecoder.decodeObject(forKey: "nextSibling") as? MindMapTreeNode)
        self.pointPosition=(aDecoder.decodeObject(forKey: "pointPosition") as? CGPoint)!
        self.depthNode=aDecoder.decodeInteger(forKey: "depthNode")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.element, forKey: "element")
        aCoder.encode(self.identification, forKey: "identification")
        aCoder.encode(self.firstChild, forKey: "firstChild")
        aCoder.encode(self.nextSibling, forKey: "nextSibling")
        aCoder.encode(self.pointPosition, forKey: "pointPosition")
        aCoder.encode(self.depthNode, forKey: "depthNode")
    }
    
}

/*
    记录父结点与子结点之间的关系
 */
class LineNode:NSObject{
    var startNode:MindMapTreeNode!
    var endNode:MindMapTreeNode!
}
