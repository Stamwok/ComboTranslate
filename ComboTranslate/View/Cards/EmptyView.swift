//
//  EmptyView.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 22.10.21.
//

import UIKit

class EmptyView: CardView {
    
    @IBOutlet var circleProgressView: CircleProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureCardView() {
        guard let contentViewFromNib = Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)?[0] as? UIView else { return }
        contentView = contentViewFromNib
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
}
