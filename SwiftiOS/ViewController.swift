//
//  ViewController.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/1.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonData  = """
    {
        "id": 0,
        "imageUrl": "",
        "productCategoryCode": "",
        "productCategoryEngName": "",
        "productCategoryName": "",
        "productCategoryPath": "",
        "productParentId": 0,
        "productSort": 0,
        "subCategoryList": [
            {
                "id": 0,
                "imageUrl": "",
                "productCategoryCode": "",
                "productCategoryEngName": "",
                "productCategoryName": "",
                "productCategoryPath": "",
                "productParentId": 0,
                "productSort": 0,
                "subCategoryList": []
            }
        ]
    }
""".data(using: .utf8)!
        //        let obj =
        do {
            let entity = try JSONDecoder().decode(HlSortEntityLevel.self, from: jsonData)
            print(entity.subCategoryList)
        } catch  {
            print(error)
        }
    }
    
    
    @IBAction func leftItemAction(_ sender: Any) {
        AppRouter.shared.route(to: URL(string: UniversalLinks.generatePath(path: .main)), from: self, userInfo: [AppRoutingInfoKey.object : "Main"], using: .show)
    }
    
    @IBAction func rightItemAction(_ sender: Any) {
        AppRouter.shared.route(to: URL(string: UniversalLinks.generatePath(path: .test)), from: self, userInfo: [AppRoutingInfoKey.object : "Test"], using: .show)
    }
    
    @objc private func buttonAction() {
        
    }
    
}

class HlSortEntity: Codable {
    let id: Int?
    let imageUrl: String?
    let productCategoryCode: String?
    let productCategoryEngName: String?
    let productCategoryName: String?
    let productCategoryPath: String?
    let productParentId: Int?
    let productSort: Int?
    
}

class HlSortEntityLevel: HlSortEntity {
    var subCategoryList: [HlSortEntity]?
    private enum CodingKeys: String, CodingKey { case subCategoryList }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        subCategoryList = try container.decodeIfPresent([HlSortEntity].self, forKey: .subCategoryList)
        try super.init(from: decoder)
    }
    
}
