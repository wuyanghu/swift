//
//  JigsawCollectionViewCell.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/25.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

class JigsawCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView.init(frame: self.bounds)
        self.addSubview(imageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
