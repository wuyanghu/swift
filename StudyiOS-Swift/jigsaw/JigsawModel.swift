//
//  JigsawModel.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/24.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

enum JigsawType:NSInteger {
    case easy,middle,diffcult
}

class JigsawModel: NSObject {
    var ident:Int = -1 //标识图片
    var index:NSInteger = -1//图形所在的位置
    var imageView:UIImageView!
}
