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
    var contents: Results<Contents>!
    var db: Firestore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userIDLabel.text = "UserID:\(userID)"
        print(contents.count)
    }
    
    @IBAction func saveContetns(_ sender: Any) {
        
        if contents.count != 0 {
            HUD.show(.labeledProgress(title: "", subtitle: "データをアップロードしています。"))
            saveButtonTaped()
        }
        
    }
    
    private func saveButtonTaped() {
        for content in contents {
            
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
                "UpDouwn": upDown,
                "AcSlide": acSlide
            ])
        }
    }
    
    @IBAction func getContents(_ sender: Any) {
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
                HUD.hide()
            } else {
                HUD.hide()
            }
        }
    }
    
}
