//
//  FirebaseViewController.swift
//  303 Patterns Note
//
//  Created by 服部　翼 on 2020/02/21.
//  Copyright © 2020 服部翼. All rights reserved.
//

import UIKit
import Instantiate
import InstantiateStandard
import RealmSwift
import Firebase
import PKHUD

class FirebaseViewController: UIViewController, StoryboardInstantiatable {
    
    @IBOutlet weak var userIDLabel: UILabel!
    var userID: String = ""
    var resultsContents: Results<Contents>!
    var db: Firestore = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIDLabel.text = "UserID:\(userID)"
        print(resultsContents.count)
    }
    
    @IBAction func saveContetns(_ sender: Any) {
        
        if resultsContents.count != 0 {
            HUD.show(.labeledProgress(title: "", subtitle: "データをアップロードしています。"))
            saveButtonTaped()
        } else {
            
        }
        
    }
    
    
    @IBAction func getContents(_ sender: Any) {
        HUD.show(.labeledProgress(title: "", subtitle: "データを取得しています。"))
        referenceContents()
    }
    
    @IBAction func getAnotherIDContents(_ sender: Any) {
        
        let alert = UIAlertController(title: "IDを入力してください", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        self.present(alert, animated: false)
    }
}

extension FirebaseViewController {
    
    private func fireStoreAddData(data: [String: Any]) {
        
        let ref = Firestore.firestore()
            .collection("UserID").document(userID)
            .collection("Item")
        
        ref.addDocument(data: data) { (error) in
            if let error = error {
                print(error.localizedDescription)
                HUD.flash(.labeledError(title: "Failed", subtitle: "アップロードに失敗しました。"), delay: 1.0)
            } else {
                HUD.flash(.labeledSuccess(title: "Success!", subtitle: "アップロードに成功しました。"), delay: 1.0)
            }
        }
    }
    
    private func saveButtonTaped() {
        for content in resultsContents {
            
            var note = [String]()
            var upDown = [String]()
            var acSlide = [String]()
            
            content.note.forEach {note.append($0.note)}
            content.upDown.forEach {upDown.append($0.updown)}
            content.acSlide.forEach {acSlide.append($0.acSlide)}
            
            fireStoreAddData(data: [
                "Name": content.name,
                "Date": content.date,
                "Note": note,
                "UpDown": upDown,
                "AcSlide": acSlide
            ])
        }
    }
    
    
    private func referenceContents() {
        
        let realm = try! Realm()
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("error")
        }
        
        let ref = Firestore.firestore()
            .collection("UserID").document(userID).collection("Item")
        
        ref.getDocuments { (snapShot, error) in
            if let error = error {
                print(error.localizedDescription)
                HUD.flash(.labeledError(title: "Failed", subtitle: "失敗しました。"), delay: 1.0)
            } else {
                guard let snapShot = snapShot else {return}
                self.addContents(documents: snapShot.documents, realm: realm)
                HUD.flash(.labeledSuccess(title: "Success!", subtitle: "データを取得しました。"), delay: 1.0)
            }
        }
    }
    
    
    
    private func addContents(documents: [QueryDocumentSnapshot], realm: Realm) {
        for document in documents {
            
            let contents = Contents()
            let snapShotValue = document.data()
            contents.name = snapShotValue["Name"] as! String
            contents.date = (snapShotValue["Date"] as! Timestamp).dateValue()
            
            (snapShotValue["Note"] as! [String]).forEach { (note) in
                contents.note.append(Note(value: ["note": note]))
            }
            
            (snapShotValue["UpDown"] as! [String]).forEach { (upDown) in
                contents.upDown.append(UpDown(value: ["updown":upDown]))
            }
            
            (snapShotValue["AcSlide"] as! [String]).forEach { (acSlide) in
                contents.acSlide.append(AcSlide(value: ["acSlide":acSlide]))
            }
            
            
            do {
                try realm.write {
                    realm.add(contents)
                }
            } catch {
                print("realm_Error")
            }
        }
    }
}
