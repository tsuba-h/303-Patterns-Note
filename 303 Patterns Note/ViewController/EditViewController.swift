//
//  EditViewController.swift
//  303 Patterns Note
//
//  Created by 服部翼 on 2019/09/05.
//  Copyright © 2019 服部翼. All rights reserved.
//

import UIKit
import RealmSwift
import FontAwesome_swift

class EditViewController: UIViewController {
    
    @IBOutlet var noteLabel: [UILabel]!
    @IBOutlet var downUpLabel: [UILabel]!
    @IBOutlet var acSlideLabel: [UILabel]!
    @IBOutlet var seqLabel: [UILabel]!
    
    var seqCount = 1
    var udCount = 0
    var acSlideCount = [false,false]
    var note = [String](repeating: "", count: 16)
    var upDown = [String](repeating: "", count: 16)
    var acSlide = [String](repeating: "", count: 16)
    var seqPointColor = UIColor(red: 245/255, green: 130/255, blue: 12/255, alpha: 1)
    var days: String?
    var name: String?
    
    private let mediumFeedbackGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        return generator
    }()
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var seqCountLabel: UILabel!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var daysLabel: UILabel!
    
    let realm = try! Realm()
    let contents = Contents()
    var itemCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seqCountLabel.text = String(seqCount)
        nextButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        nextButton.setTitle(String.fontAwesomeIcon(name: .angleDoubleRight), for: .normal)
        backButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        backButton.setTitle(String.fontAwesomeIcon(name: .angleDoubleLeft), for: .normal)
        
        seqCountLabel.layer.cornerRadius = 6.0
        seqCountLabel.layer.shadowColor = UIColor.gray.cgColor
        seqCountLabel.layer.shadowOpacity = 0.8
        seqCountLabel.layer.shadowOffset = CGSize(width: 3, height: 6)
    
        
        if itemCount != nil {
            for count in 0...15 {
                noteLabel[count].text = note[count]
                downUpLabel[count].text = upDown[count]
                acSlideLabel[count].text = acSlide[count]
            }
            if let name = name {
                titleText.text = name
            }
            
            if let days = days {
                daysLabel.text = days
            }
        }
        seqColor()
        udCountJudg()
        acSlideJudg()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    @IBAction func keyBoard(_ sender: Any) {
        let tag = (sender as! UIButton).tag
        mediumFeedbackGenerator.impactOccurred()
        switch tag {
        case 0:
            noteText("C")
        case 1:
            noteText("C#")
        case 2:
            noteText("D")
        case 3:
            noteText("D#")
        case 4:
            noteText("E")
        case 5:
            noteText("F")
        case 6:
            noteText("F#")
        case 7:
            noteText("G")
        case 8:
            noteText("G#")
        case 9:
            noteText("A")
        case 10:
            noteText("A#")
        case 11:
            noteText("B")
        case 12:
            noteText("C hi")
        default:
            break
        }
    }
    
    func noteText(_ key: String) {
        note[seqCount - 1] = key
        noteLabel[seqCount - 1].text = note[seqCount - 1]
    }
    
    @IBAction func acSlideButton(_ sender: Any) {
        mediumFeedbackGenerator.impactOccurred()
        let tag = (sender as! UIButton).tag
        if tag == 20 {
            //accent
            if acSlideCount[0] == false {
                acSlideCount[0] = true
            } else {
                acSlideCount[0] = false
            }
        } else if tag == 21 {
            //slide
            if acSlideCount[1] == false {
                acSlideCount[1] = true
            } else {
                acSlideCount[1] = false
            }
        }
    
        switch acSlideCount {
        case [false, false]:
            acSlideText("")
        case [true, false]:
            acSlideText("A")
        case [false, true]:
            acSlideText("S")
        case [true, true]:
            acSlideText("A/S")
        default:
            break
        }
    }
    
    func acSlideText(_ item:String) {
        acSlide[seqCount - 1] = item
        acSlideLabel[seqCount - 1].text = acSlide[seqCount - 1]
    }
    
    @IBAction func upDownButton(_ sender: Any) {
        mediumFeedbackGenerator.impactOccurred()
        if noteLabel[seqCount - 1].text == "" {
            return
        }
        let tag = (sender as! UIButton).tag
        if tag == 15 {
            //Down
            if udCount == -1 {
                udCount = -1
            } else {
                udCount -= 1
            }
        } else if tag == 16 {
            //Up
            if udCount == 1 {
                udCount = 1
            } else {
                udCount += 1
            }
        }
        
        switch udCount {
        case -1:
            upDownText("D")
        case 0:
            upDownText("")
        case 1:
            upDownText("U")
        default:
            break
        }
    }
    
    func upDownText(_ item:String) {
        upDown[seqCount - 1] = item
        downUpLabel[seqCount - 1].text = upDown[seqCount - 1]
    }
    
    @IBAction func backButton(_ sender: Any) {
        seqCount -= 1
        if seqCount == 0 {
            seqCount = 16
        }
        seqCountLabel.text = String(seqCount)
        
        seqColor()
        udCountJudg()
        acSlideJudg()
        mediumFeedbackGenerator.impactOccurred()
    }
    @IBAction func nextButton(_ sender: Any) {
        seqCount += 1
        if seqCount == 17 {
            seqCount = 1
        }
        seqCountLabel.text = String(seqCount)
       
        seqColor()
        udCountJudg()
        acSlideJudg()
        mediumFeedbackGenerator.impactOccurred()
    }
    
    func seqColor() {
        for seq in seqLabel {
            if #available(iOS 13.0, *) {
                seqLabel[0].backgroundColor = UIColor(named: "grayLabel")
                seqLabel[4].backgroundColor = UIColor(named: "grayLabel")
                seqLabel[8].backgroundColor = UIColor(named: "grayLabel")
                seqLabel[12].backgroundColor = UIColor(named: "grayLabel")
                seq.backgroundColor = UIColor(named: "whiteKeyboard")
            } else {
                seqLabel[0].backgroundColor = .groupTableViewBackground
                seqLabel[4].backgroundColor = .groupTableViewBackground
                seqLabel[8].backgroundColor = .groupTableViewBackground
                seqLabel[12].backgroundColor = .groupTableViewBackground
                seq.backgroundColor = .white
            }
        }
        if #available(iOS 13.0, *) {
            seqLabel[seqCount - 1].backgroundColor = UIColor(named: "SEQLabel")
        } else {
            seqLabel[seqCount - 1].backgroundColor = seqPointColor
        }
    }
    
    func udCountJudg() {
        switch downUpLabel[seqCount - 1].text {
        case "D":
            udCount = -1
        case "":
            udCount = 0
        case "U":
            udCount = 1
        default:
            break
        }
    }
    
    func acSlideJudg() {
        switch acSlideLabel[seqCount - 1].text {
        case "":
            acSlideCount = [false, false]
        case "A":
            acSlideCount = [true, false]
        case "S":
            acSlideCount = [false, true]
        case "A/S":
            acSlideCount = [true, true]
        default:
            break
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        mediumFeedbackGenerator.impactOccurred()
        noteText("")
        upDownText("")
        acSlideText("")
        udCount = 0
        acSlideCount = [false, false]
    }
    
    @IBAction func saveButton(_ sender: Any) {
        var count = 0
        
        if titleText.text == "" {
            titleAlert()
        } else {
            note.forEach { (note) in
                if note == "" {
                    count += 1
                }
            }
        }
        
        if count == 16 {
            noteAlert()
        } else {
            contents.name = titleText.text!
            contents.date = Date()
            for note in note {
                contents.note.append(Note(value: ["note":note]))
            }
            for upDown in upDown {
                contents.upDown.append(UpDown(value: ["updown":upDown]))
            }
            for acSlide in acSlide {
                contents.acSlide.append(AcSlide(value: ["acSlide":acSlide]))
            }
            
            do {
                if itemCount == nil {
                    try  realm.write {
                        realm.add(contents)
                    }
                } else {
                    let results = realm.objects(Contents.self).sorted(
                        byKeyPath: UserDefaults.standard.string(forKey: "sort") ?? "date",
                        ascending: UserDefaults.standard.bool(forKey: "ascending"))
                    print(results[itemCount!])
                    try realm.write {
                        if let itemCount = itemCount {
                            realm.delete(results[itemCount].note)
                            realm.delete(results[itemCount].upDown)
                            realm.delete(results[itemCount].acSlide)
                            realm.delete(results[itemCount])
                            
                            realm.add(contents)
                        }
                    }
                }
            } catch {
                print(error)
            }
            
            navigationController?.popViewController(animated: true)
        }
        
    
}
    
    func titleAlert() {
        let alert = UIAlertController(title: "タイトルを入力してください", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func noteAlert() {
        let alert = UIAlertController(title: "Noteを1つ以上入力してください", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


