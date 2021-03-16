//
//  ViewController.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/1.
//

import UIKit
import GRDB

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "主页"
    }
    
    @IBAction func leftItemAction(_ sender: Any) {
        Player.insertRows()
    }
    @objc private func buttonAction() {
        
    }
    
    func synchronized<T>(_ lock: AnyObject, _ closure: () throws -> T) rethrows -> T {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        return try closure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
