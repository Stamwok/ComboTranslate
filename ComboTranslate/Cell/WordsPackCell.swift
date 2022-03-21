//
//  WordsPackCell.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 7.02.22.
//

import UIKit

class WordsPackCell: UITableViewCell {
    
    weak var delegate: WordsPackController?
    
    @IBOutlet var packName: UILabel!
    @IBOutlet var shortList: UILabel!
    @IBOutlet var wordsCount: UILabel!
    @IBOutlet var progress: VerticalProgressView!
    @IBOutlet var editButton: UIButton?
    @IBAction func editPack(_: UIButton) {
        delegate?.editPack(cell: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        editButton?.layer.shadowOpacity = 0.5
        editButton?.layer.shadowOffset = CGSize(width: 2, height: 2)
        editButton?.layer.shadowColor = UIColor.black.cgColor
        editButton?.layer.shadowRadius = 2
        editButton?.clipsToBounds = true
        
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        self.isSelected = false
//        // Configure the view for the selected state
//    }

}
