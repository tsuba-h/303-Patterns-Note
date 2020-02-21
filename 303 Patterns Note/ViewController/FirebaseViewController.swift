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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveContetns(_ sender: Any) {
    }
    
    @IBAction func getContents(_ sender: Any) {
    }
    
    @IBAction func getAnotherIDContents(_ sender: Any) {
    }
}
