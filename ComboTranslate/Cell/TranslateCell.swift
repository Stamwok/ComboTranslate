//
//  TableViewCell.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 23.09.21.
//

import UIKit

class TranslateCell: UITableViewCell {
    @IBOutlet var translateLabel: UILabel!
    @IBOutlet var translatedLabel: UILabel!
    @IBOutlet var progress: UIProgressView!
    @IBOutlet var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        view.layer.cornerRadius = 15
//        view.clipsToBounds = true
//    }
}
