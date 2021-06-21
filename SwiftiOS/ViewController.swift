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
    
    
    let button = UIButton(frame: CGRect(x: 10, y: 100, width: 100, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle("normal", for: .normal)
        button.setTitle("selected", for: .selected)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.red, for: .selected)
        button.addTarget(self, action: #selector(buttoClick(sender:)), for: .touchUpInside)
        view.addSubview(button)
        imageView.contentMode = .scaleToFill
        resizeImageView.contentMode = .scaleToFill
        guard let path = Bundle.main.path(forResource: "111", ofType: "jpeg"), let image = UIImage(contentsOfFile: path) else { return }
        let redraw = image.redraw(scale: .width(100), scaleFactor: 1)
        imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y, width: image.size.width, height: image.size.height)
        resizeImageView.frame = CGRect(x: resizeImageView.frame.origin.x, y: resizeImageView.frame.origin.y, width: redraw?.size.width ?? 0, height: redraw?.size.height ?? 0)
        imageView.image = image
        resizeImageView.image = redraw
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var resizeImageView: UIImageView!
    
    @objc func buttoClick(sender: UIButton) {
        
    }
    
    @IBAction func leftItemAction(_ sender: Any) {
        
    }
    
    @IBAction func rightItemAction(_ sender: Any) {
        
    }
    
    @objc private func buttonAction() {
        
    }
    
}
