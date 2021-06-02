//
//  ViewController.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/1.
//

import UIKit
import Cache
import SnapKit

class ViewController: UIViewController {

    let storage = MemoryStorage<Date, String>.init(config: MemoryConfig(expiry: .never, countLimit: 100, totalCostLimit: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        button.setTitle("点击", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(buttoClick(sender:)), for: .touchUpInside)
        button.backgroundColor = .cyan
        view.addSubview(button)
    }
    
    
    @objc func buttoClick(sender: UIButton) {
        let viewArray = (0 ..< 5).map { index -> MenuItem in
            let item = MenuItem(title: "测试\(index)", image: UIImage(named: "message_video_goback")) {
                print(index)
            }
            return item
        }
        MenuView.show(from: sender, style: .horizontal, items: viewArray)
    }
    
    @IBAction func leftItemAction(_ sender: Any) {
        
    }
    
    @IBAction func rightItemAction(_ sender: Any) {
        AppRouter.shared.route(to: URL(string: UniversalLinks.generatePath(path: .test)), from: self, userInfo: [AppRoutingInfoKey.object : "Test"], using: .show)
    }
    
    @objc private func buttonAction() {
        
    }
    
}
