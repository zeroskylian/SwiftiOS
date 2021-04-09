//
//  ViewController.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/1.
//

import UIKit
import GRDB
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var tf: UITextField!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "主页"
        tf.keyboardAppearance = .dark
        
        let a: AttributeString = "lian \("xin",.color(ColorAssets.ttt.color),.font(.systemFont(ofSize: 17)))"
        tf.attributedText = a.attributedString
    }
    
    
    @IBAction func leftItemAction(_ sender: Any) {
        AppRouter.shared.route(to: URL(string: UniversalLinks.generatePath(path: .main)), from: self, userInfo: [AppRoutingInfoKey.object : "Main"], using: .show)
    }
    
    @IBAction func rightItemAction(_ sender: Any) {
        AppRouter.shared.route(to: URL(string: UniversalLinks.generatePath(path: .test)), from: self, userInfo: [AppRoutingInfoKey.object : "Test"], using: .show)
    }
    @objc private func buttonAction() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
