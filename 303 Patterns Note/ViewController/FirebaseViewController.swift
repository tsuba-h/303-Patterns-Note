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

class FirebaseViewController: UIViewController, StoryboardInstantiatable {
    
    @IBOutlet weak var userIDLabel: UILabel!
    var userID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userIDLabel.text = "UserID:\(userID)"
    }
    
    @IBAction func saveContetns(_ sender: Any) {
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
