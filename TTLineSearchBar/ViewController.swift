//
//  ViewController.swift
//  TTLineSearchBar
//
//  Created by 谢许峰 on 15/6/14.
//  Copyright (c) 2015年 tifatsubasa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
        var lineSearchBar = TTLineSearchBar(frame: CGRectMake(100, 300, 200, 30))
        self.view.addSubview(lineSearchBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

