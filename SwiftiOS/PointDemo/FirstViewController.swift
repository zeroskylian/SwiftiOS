//
//  ViewController.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/1.
//

import UIKit

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        title = "主页"
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 88, width: view.frame.width, height: 200), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        view.addSubview(tableView)
        extendedLayoutIncludesOpaqueBars = true
        
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
        
        
        
        let current = Date()
        let next = current.addingTimeInterval(-60 * 60 * 24 - 30)
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_cn")
        formatter.dateFormat = "EEEE"
        print(formatter.string(from: next))
    }
    
    @objc private func showNext() {
        let vc = ViewController()
        navigationController?.pushViewController(vc, animated: true)
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


extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.backgroundColor = .cyan
        cell.textLabel?.text = "\(indexPath.row)"
        cell.accessibilityIdentifier = "TableViewCell \(indexPath.row)"
        return cell
    }
}

extension FirstViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension FirstViewController: UICollectionViewDataSource {
    
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
