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
    
    let operationQueue: OperationQueue = {
        let queue =  OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    let dispathcQueue = DispatchQueue(label: "com.test")
    
    lazy var session: Alamofire.Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 14
        let session = Alamofire.Session(configuration: config, startRequestsImmediately: false, requestQueue: self.dispathcQueue)
        return session
    }()
    
    lazy var requests: [DataRequest] = {
        return (1 ... 4).map { (index) in
            return generateRequest(index: index)
        }
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "主页"
        tf.keyboardAppearance = .dark
        
        let a: AttributeString = "lian \("xin",.color(ColorAssets.ttt.color),.font(.systemFont(ofSize: 17)))"
        tf.attributedText = a.attributedString
        
        let imageView = UIImageView(image: Asset.iconDispalyDisable.image)
        imageView.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
        view.addSubview(imageView)
    }
    
    func generateRequest(index: Int) -> DataRequest{
        let url = URL(string: "http://httpbin.org/get?i=\(index)")!
        let req = session.request(url, method: .get)
        req.responseString { (response) in
            switch response.result {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return req
    }
    
    
    @IBAction func leftItemAction(_ sender: Any) {

        for (index,req) in requests.enumerated() {
            print("start-\(index)")
            req.resume()
            print("end-\(index)")
        }
        print("finff")
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
