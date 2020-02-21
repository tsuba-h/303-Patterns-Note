//
//  ViewControllerCollectionViewCell.swift
//  303 Patterns Note
//
//  Created by 服部翼 on 2019/09/24.
//  Copyright © 2019 服部翼. All rights reserved.
//

import UIKit
import FontAwesome_swift

protocol CellButtonDelegate {
    func buttonTap(cell: ViewControllerCollectionViewCell)
}

class ViewControllerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: CellButtonDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//
//        deleteButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
//        deleteButton.setTitle(String.fontAwesomeIcon(name: .trashAlt), for: .normal)
    }

    @IBAction func buttonTap(_ sender: Any) {
        delegate.buttonTap(cell: self)
    }
}
