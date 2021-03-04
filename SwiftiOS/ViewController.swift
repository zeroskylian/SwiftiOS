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
        view.backgroundColor = .white
        title = "主页"
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 88, width: view.frame.width, height: 200), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: tableView.frame.maxY, width: view.frame.width, height: 200), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        view.addSubview(collectionView)
        
        
        let imageView = UIImageView(frame: CGRect(x: 100, y: collectionView.frame.maxY + 40, width: 80, height: 80))
        imageView.image = UIImage(named: "tieba")
        imageView.isUserInteractionEnabled = true
        imageView.accessibilityIdentifier = "百度图片"
        view.addSubview(imageView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showNext))
        imageView.addGestureRecognizer(tap)
        
        let button = UIButton(frame: CGRect(x: 200, y: collectionView.frame.maxY + 40, width: 80, height: 80))
        button.backgroundColor = .cyan
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.accessibilityIdentifier = "百度按钮"
        view.addSubview(button)
        
        let _ = TestView()
    }
    
    @objc private func showNext() {
        let vc = ViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private var total: Int = 0
    
    private let lock: NSLock = NSLock()
    
    let queue = DispatchQueue.init(label: "com.test",attributes: .concurrent)
    
    
    @objc private func buttonAction() {
        
        for i in 0 ... 4 {
            queue.sync {
                self.synchronized(self) {
                    aaa += i
                    print("aaa \(aaa)")
                    aaa -= i
                    print("aaa \(aaa)")
                }
            }
        }
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

var aaa = 0
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.accessibilityIdentifier = "TableViewCell \(indexPath.row)"
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.backgroundColor = .orange
        cell.accessibilityIdentifier = "CollectionViewCell \(indexPath.row)"
        return cell
    }
}
