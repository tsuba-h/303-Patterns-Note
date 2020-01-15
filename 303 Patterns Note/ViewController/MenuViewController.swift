//
//  MenuViewController.swift
//  303 Patterns Note
//
//  Created by 服部翼 on 2019/10/03.
//  Copyright © 2019 服部翼. All rights reserved.
//

import UIKit
import RealmSwift

protocol CollectionViewReloadDelegate {
    func reload()
    func sorted()
    func layout()
}

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var delegate: CollectionViewReloadDelegate!
    var contents: Results<Contents>!
    var naviHeight: CGFloat?
    
    let feedImpact: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        let menuPosition = self.tableView.layer.position
        self.tableView.layer.position.x = -self.tableView.frame.width
        UIView.animate(withDuration: 0.4) {
            self.tableView.layer.position.x = menuPosition.x
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 20
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       tableViewDismiss()
    }
    
    func tableViewDismiss() {
        UIView.animate(withDuration: 0.4, animations: {
            self.tableView.layer.position.x = -self.tableView.frame.width
        }) { (complete) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.titleLabel?.text = "名前順"
                if UserDefaults.standard.string(forKey: "sort") == "name" {
                    cell.checkImage.isHidden = false
                } else {
                    cell.checkImage.isHidden = true
                }
            case 1:
                cell.titleLabel.text = "更新順"
                if UserDefaults.standard.object(forKey: "sort") == nil {
                    cell.checkImage.isHidden = false
                } else if UserDefaults.standard.string(forKey: "sort") == "date" {
                    cell.checkImage.isHidden = false
                } else {
                    cell.checkImage.isHidden = true
                }
            default:
                return cell
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "3"
                if UserDefaults.standard.object(forKey: "cellLayout") == nil {
                    cell.checkImage.isHidden = false
                } else if UserDefaults.standard.integer(forKey: "cellLayout") == 3 {
                    cell.checkImage.isHidden = false
                } else {
                    cell.checkImage.isHidden = true
                }
            case 1:
                cell.titleLabel.text = "4"
                if UserDefaults.standard.integer(forKey: "cellLayout") == 4 {
                    cell.checkImage.isHidden = false
                } else {
                    cell.checkImage.isHidden = true
                }
            default:
                return cell
            }
        case 2:
            cell.titleLabel.text = "データの全削除"
            cell.checkImage.isHidden = true
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        feedImpact.impactOccurred()
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                UserDefaults.standard.set("name", forKey: "sort")
                UserDefaults.standard.set(true, forKey: "ascending")
                self.delegate.sorted()
                tableView.reloadData()
            case 1:
                UserDefaults.standard.set("date", forKey: "sort")
                UserDefaults.standard.set(false, forKey: "ascending")
                self.delegate.sorted()
                tableView.reloadData()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                UserDefaults.standard.set(3, forKey: "cellLayout")
                self.delegate.layout()
                tableView.reloadData()
            case 1:
                UserDefaults.standard.set(4, forKey: "cellLayout")
                self.delegate.layout()
                tableView.reloadData()
            default:
                break
            }
        case 2:
            do {
                let realm = try Realm()
                contents = realm.objects(Contents.self)
            } catch {
                print(error)
            }
            if contents.count == 0 {
                let alert = UIAlertController(title: "データがありません", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "全てのデータを削除しますが、本当によろしいですか？", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    let realm = try! Realm()
                    do {
                        try realm.write {
                            realm.deleteAll()
                        }
                    } catch {
                        print("error")
                    }
                    
                    DispatchQueue.global().async {
                        
                        DispatchQueue.main.async {
                            self.delegate.reload()
                        }
            
                        DispatchQueue.main.async {
                            self.tableViewDismiss()
                        }
                    }
                }
                let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
                alert.addAction(cancel)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "並び順"
        case 1:
            return "表示数"
        case 2:
            return "データの削除"
        default:
            return ""
        }
    }
}
