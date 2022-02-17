//
//  EditorCollectionViewCell.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 10.02.22.
//

import UIKit

class EditorCollectionViewCell: UICollectionViewCell {
    
    static let nib = UINib(nibName: String(describing: EditorCollectionViewCell.self), bundle: nil)
    static let reuseID = String(describing: EditorCollectionViewCell.self)
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var colorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15
    }
    func select() {
        self.colorView.backgroundColor = UIColor(hex: "2E8EEF")
        self.label.textColor = .white
        self.imageView.isHidden = false
    }
    func deselect() {
        self.colorView.backgroundColor = UIColor(hex: "A5A8AC1A")
        self.label.textColor = .lightGray
        self.imageView.isHidden = true
    }
}
