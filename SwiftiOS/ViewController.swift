//
//  ViewController.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/1.
//

import Cache
import SnapKit
import UIKit
import Logging

class ViewController: UIViewController {
    let button = UIButton(frame: CGRect(x: 10, y: 100, width: 100, height: 50))
    
    var logger = Logger(label: "com.example.BestExampleApp.main")
    
    let dataSource: [UIFont.TextStyle] = [.largeTitle, .title1, .title2, .title3, .headline, .subheadline, .body, .callout, .footnote, .caption1, .caption1]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle("normal", for: .normal)
        button.setTitle("selected", for: .selected)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.red, for: .selected)
        button.addTarget(self, action: #selector(buttoClick(sender:)), for: .touchUpInside)
        view.addSubview(button)
       
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var resizeImageView: UIImageView!
    
    @objc func buttoClick(sender: UIButton) {}
    
    @IBAction func leftItemAction(_ sender: Any) {}
    
    @IBAction func rightItemAction(_ sender: Any) {}
    
    @objc private func buttonAction() {}
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        logger[metadataKey: "request-uuid"] = "\(UUID())"
        logger.info("hello world", file: #file, line: #line)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.font = .preferredFont(forTextStyle: dataSource[indexPath.row])
        cell.textLabel?.text = "\(dataSource[indexPath.row].rawValue)"
        cell.textLabel?.textColor = .black
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
}
