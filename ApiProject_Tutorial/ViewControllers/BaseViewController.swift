//
//  BaseViewController.swift
//  ApiProject_Tutorial
//
//  Created by 김동환 on 2021/03/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    var titleText: String = ""{
        didSet{
            self.title = titleText
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
