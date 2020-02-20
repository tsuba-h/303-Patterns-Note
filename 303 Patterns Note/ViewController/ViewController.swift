//
//  ViewController.swift
//  303 Patterns Note
//
//  Created by 服部翼 on 2019/09/05.
//  Copyright © 2019 服部翼. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var notItemView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var contents: Results<Contents>!
    var sort = UserDefaults.standard.string(forKey: "sort") ?? "date"
    
    private let dateFormatter: DateFormatter = {
           let date = DateFormatter()
           date.dateFormat = "yyyy-MM-dd"
           return date
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "ViewControllerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ViewControllerCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("sprt:::\(sort)")
        do {
            let realm = try Realm()
            
            print("realm保存場所",Realm.Configuration.defaultConfiguration.fileURL!)
            contents = realm.objects(Contents.self).sorted(
                byKeyPath: UserDefaults.standard.string(forKey: "sort") ?? "date",
                ascending: UserDefaults.standard.bool(forKey: "ascending"))
        } catch {
            print(error)
        }
        
        collectionView.reloadData()
        if contents.count == 0 {
            notItemView.isHidden = false
        } else {
            notItemView.isHidden = true
        }
    }
    
    @IBAction func sideMenuButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "MenuViewController", bundle: nil)
        let sideMenuView = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        sideMenuView.naviHeight = self.navigationController?.navigationBar.frame.size.height
        sideMenuView.modalTransitionStyle = .crossDissolve
        sideMenuView.delegate = self
        present(sideMenuView, animated: true, completion: nil)
    }
    
    @IBAction func editViewSegue(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EditViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        vc.id = Randomize().generate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewControllerCollectionViewCell", for: indexPath) as! ViewControllerCollectionViewCell
        cell.titleLabel.text = contents[indexPath.row].name
        cell.daysLabel.text = dateFormatter.string(from: contents[indexPath.row].date)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var sendNote = [String]()
        var sendUpDown = [String]()
        var sendAcSlide = [String]()
        if let vc = UIStoryboard(name: "EditViewController", bundle: nil).instantiateViewController(withIdentifier: "EditViewController") as? EditViewController {
            
            for notes in contents[indexPath.row].note {
                sendNote.append(notes.note)
            }
            for upDowns in contents[indexPath.row].upDown {
                sendUpDown.append(upDowns.updown)
            }
            for acSlides in contents[indexPath.row].acSlide {
                sendAcSlide.append(acSlides.acSlide)
            }
            
            vc.itemIndex = indexPath.row
            vc.id = contents[indexPath.row].id
            vc.name = contents[indexPath.row].name
            vc.days = dateFormatter.string(from: contents[indexPath.row].date)
            vc.note = sendNote
            vc.upDown = sendUpDown
            vc.acSlide = sendAcSlide
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth = 3
        if UserDefaults.standard.object(forKey: "cellLayout") != nil {
            cellWidth = UserDefaults.standard.integer(forKey: "cellLayout")
        }
        
        let height = (collectionView.bounds.height / 2) - 8
        let width = (collectionView.bounds.width / CGFloat(cellWidth))
        return CGSize(width: width, height: height)
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ViewController: CellButtonDelegate {
    
    func buttonTap(cell: ViewControllerCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let alert = UIAlertController(title: "このデータを削除してもよろしいですが？", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    let results = self.contents[indexPath.row]
                    let realm = try! Realm()
                    do {
                        
                        try realm.write {
                            realm.delete(results.note)
                            realm.delete(results.upDown)
                            realm.delete(results.acSlide)
                            realm.delete(results)
                        }
                    } catch {
                        print(error)
                    }
                    self.collectionView.deleteItems(at: [indexPath])
                    self.collectionView.reloadData()
                    if self.contents.count == 0 {
                        self.notItemView.isHidden = false
                    }
                }
                let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
                alert.addAction(cancel)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        }
}

extension ViewController: CollectionViewReloadDelegate {
    func reload() {
        self.collectionView.reloadData()
        if contents.count == 0 {
            notItemView.isHidden = false
        }
    }
    
    func sorted() {
        do {
            let realm = try Realm()
            contents = realm.objects(Contents.self).sorted(
                byKeyPath: UserDefaults.standard.string(forKey: "sort") ?? "date",
                ascending: UserDefaults.standard.bool(forKey: "ascending"))
        } catch {
            print(error)
        }
        self.collectionView.reloadData()
    }
    
    func layout() {
        self.collectionView.reloadData()
    }
    
}

