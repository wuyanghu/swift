//
//  SudokuModel.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/28.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

let valueInit = -1

class SudokuModel: NSObject {
    
    var point:CGPoint!//图形所在的位置
    var label:UILabel!
    
    /*
     产生一个1-9的不重复长度为9的一维数组
     每次添加一个数字，添加后跳出循环
     */
    func creatNineRondomArray() -> Array<Int> {
        var list = Array<Int>();

        for _ in 0..<9 {
            var randomNum:UInt32 = arc4random()%9+1;
            while (true) {
                if (!list.contains(Int(randomNum))) {
                    list.append(Int(randomNum))
                    break;
                }
                randomNum=arc4random()%9+1;
            }
            
        }
        
        var result = " "
        for value in list {
            result = "\(result) \(value)"
        }

//        print("生成的一位数组为：\(result)")
        return list
    }
    
    /**
     *<p>通过一维数组和原数组生成随机的数独矩阵</p>
     *<p>
     *遍历二维数组里的数据，在一维数组找到当前值的位置，并把一维数组
     *当前位置加一处位置的值赋到当前二维数组中。目的就是将一维数组为
     *依据，按照随机产生的顺序，将这个9个数据进行循环交换，生成一个随
     *机的数独矩阵。
     数组生成参考：http://blog.csdn.net/peng_wu01/article/details/6026103
     *</p>
     */
    func creatSudokuArray(seedArray:Array<Array<Int>>,randomList:Array<Int>) -> Array<Array<Int>>{
        var seedArray = seedArray

        for i in 0..<9 {
            for j in 0..<9 {
                for k in 0..<9 {
                    if(seedArray[i][j] == randomList[k])
                    {
                        seedArray[i][j] = randomList[(k+1)%9];
                        break;
                    }
                }
            }
        }
        print("处理后的数组\(seedArray)")
        return seedArray
    }

    
    func getSudokuArr() -> Array<Array<Int>> {
        let seedArray = [
            [9,7,8,3,1,2,6,4,5],
            [3,1,2,6,4,5,9,7,8],
            [6,4,5,9,7,8,3,1,2],
            [7,8,9,1,2,3,4,5,6],
            [1,2,3,4,5,6,7,8,9],
            [4,5,6,7,8,9,1,2,3],
            [8,9,7,2,3,1,5,6,4],
            [2,3,1,5,6,4,8,9,7],
            [5,6,4,8,9,7,2,3,1]
        ];
//        print("原始的二维数组:\(seedArray)")
        
        let randomList = creatNineRondomArray()
        return creatSudokuArray(seedArray: seedArray, randomList: randomList);
    }
}
