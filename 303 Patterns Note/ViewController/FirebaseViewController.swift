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
        
        //guard contents.count == 0 else {return}
        
        for content in contents {
            fireStoreAddData(data: [
                "Name": content.name,
                "Date": content.date
//                "Note": content.note,
//                "UpDouwn": content.upDown,
//                "AcSlide": content.acSlide
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
            }
        }
    }
    
}
