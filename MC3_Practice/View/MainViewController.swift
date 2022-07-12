//
//  ListViewController.swift
//  MC3_Practice
//
//  Created by 이창형 on 2022/07/11.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.shared.readCoreData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataManager.shared.readCoreData()
        
        navigationItem.title = "나만의 수첩"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(goToMemoVC))
        
        view.addSubview(tableView)
        applyConstraints()
        
        view.backgroundColor = UIColor(named: "backGroundColor")
        
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 20
        
        
//        self.tableView.clipsToBounds = true
//        self.tableView.layer.cornerRadius = 140
        
    }
    
    private func applyConstraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    }
    
    @objc fileprivate func goToMemoVC(){
        // 객체 인스턴스 생성
        let memoVC = MemoViewController()
        // 푸쉬한다
        self.navigationController?.pushViewController(memoVC, animated: true)
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = CoreDataManager.shared.resultArray?.count else {
            return 0
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        guard let result = CoreDataManager.shared.resultArray?.reversed()[indexPath.item] else { return UITableViewCell() }
        cell.setUI(result: result)
        
//        cell.backgroundColor = UIColor.systemGreen
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 8
//        cell.clipsToBounds = true

       
        
        
        return cell
    }
    
    
}

class MainTableViewCell: UITableViewCell {
    
//    override var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set (newFrame) {
//            var frame = newFrame
//            let newWidth = frame.width * 0.90 // get 80% width here
//            let space = (frame.width - newWidth) / 2
//
//            frame.size.width = newWidth
//            frame.origin.x += space
//
//            super.frame = frame
//
//        }
//    }
    
    var title = UILabel()
    var memo = UILabel()
    var date = UILabel()
    
    static let reuseIdentifier: String = "MainTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: date) // "January 14, 2021"
    }
    
    func setUI(result: NSManagedObject) {
        //        self.textLabel?.text = result.value(forKey: "title") as? String
        // 이곳에서 테이블 뷰 세팅
        
        
        self.title.text = result.value(forKey: "title") as? String
        self.memo.text = result.value(forKey: "memo") as? String
        if let date = result.value(forKey: "date") as? Date {
            self.date.text = getStringFromDate(date: date)
        }
              
        
        self.addSubview(title)
        self.addSubview(memo)
        self.addSubview(date)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 60).isActive = true
        title.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // 3
        memo.translatesAutoresizingMaskIntoConstraints = false
        memo.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 10).isActive = true
        memo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //
        date.translatesAutoresizingMaskIntoConstraints = false
//        date.leadingAnchor.constraint(equalTo: memo.trailingAnchor, constant: 10).isActive = true
//        date.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        date.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        date.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
    }
}
