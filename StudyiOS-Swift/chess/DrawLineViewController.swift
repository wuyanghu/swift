//
//  DrawLineViewController.swift
//  StudyiOS-Swift
//
//  Created by wupeng on 2017/7/3.
//  Copyright © 2017年 wupeng. All rights reserved.
//

import UIKit

class DrawLineViewController: UIViewController,DrawViewDelegate {
    
    var drawView:DrawView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,
                                         action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        self.title = "五子棋"
        
        // Do any additional setup after loading the view.
        let viewFrame = CGRect.init(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height-64)
        drawView = DrawView.init(frame: viewFrame)
        drawView.backgroundColor = UIColor.brown
        drawView.delegate = self
        self.view?.addSubview(drawView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backToPrevious(){
        
        self.navigationController?.popToRootViewController(animated: true);
        
    }

    //MARK:-触摸事件 DrawViewDelegate
    func chessEnd(message: String) {
        
        let alert = UIAlertController.init(title: "提示", message: String.init(format: "\(message),请重新开始"), preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            self.drawView.clickData()
        }))
        self.present(alert, animated: true, completion: nil)
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
