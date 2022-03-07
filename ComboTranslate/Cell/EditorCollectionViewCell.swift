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
    @IBOutlet var shadowView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.layer.cornerRadius = 15
        colorView.layer.cornerRadius = 15
//        colorView.clipsToBounds = false
        self.deselect()
    }
    
    func configureShadows(opacity: Float) {
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowOpacity = opacity
        shadowView.layer.shadowOffset = CGSize(width: 2, height: 2)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 2
        colorView.clipsToBounds = true
        
    }
    
    func select() {
        self.colorView.backgroundColor = UIColor(hex: "2E8EEF")
        self.label.textColor = .white
        self.imageView.isHidden = false
        configureShadows(opacity: 0.5)
    }
    func deselect() {
        self.colorView.backgroundColor = UIColor(hex: "A5A8AC1A")
        self.label.textColor = .lightGray
        self.imageView.isHidden = true
        configureShadows(opacity: 0)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.select()
            } else {
                self.deselect()
            }
        }
    }
}
