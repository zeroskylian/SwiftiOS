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
    
    
    var session: Alamofire.Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 14
        let session = Alamofire.Session(configuration: config,startRequestsImmediately: false)
        return session
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "主页"
        tf.keyboardAppearance = .dark
        
        
        let url = URL(string: "https://m.baidu.com")!
        
        let req = session.request(url, method: .get)
        req.responseString { (response) in
            print(response.result)
        }
        req.resume()
    }
    
    @IBAction func leftItemAction(_ sender: Any) {
        let jsonString =
            """
        {
                  "stuName": "小明",
                  "age": 12,
                  "body": {
                    "height": 174.4,
                    "weight": 43.2
                  },
                  "subStu": [
                  {
                    "stuName": "小明",
                    "age": 12,
                    "body": {
                      "height": 174.4,
                      "weight": 43.2
                    },
                  "subStu": null
                  }]
                }
        """
        
        do {
            let decoder = JSONDecoder()
            let s = try decoder.decode(Student.self, from: jsonString.data(using:.utf8)!)
            print(s)
        } catch  {
            print(error)
        }
        
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

struct Video: Codable {
    let commentEnabled: Bool
    
    
}

extension Date {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(TimeInterval.self)
        self = Date(timeIntervalSince1970: value)
    }
}


class Student: Codable {

    let stuName: String
    let age: Int
    let body: Body
    var subStu: [Student]?

    enum CodingKeys: String, CodingKey {
        case stuName
        case age
        case body
        case subStu
    }

}
// MARK: - Body
class Body: Codable {
    let height, weight: Double
    
}
