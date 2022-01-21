//
//  TranslatedView.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 20.01.22.
//

import UIKit

class TranslatedView: UIView {
    
    static weak var delegate: TranslatedViewDelegate?
    
    @IBOutlet var originLanguageLabel: UILabel!
    @IBOutlet var translatedLanguageLabel: UILabel!
    @IBOutlet var translateTextLabel: UILabel!
    @IBOutlet var translatedTextLabel: UILabel!
    @IBAction func closeButton(sender: UIButton) {
        TranslatedView.delegate?.closeTranslatedView()
    }
    static var originLanguage: String!
    static var translatedLanguage: String!
    static var translateText: String!
    static var translatedText: String!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    init?(originLanguage: String, translateText: String, translatedLanguage: String, translatedText: String) {
        super.init(frame: .zero)
        let contentView = Bundle.main.loadNibNamed("TranslatedView", owner: self, options: nil)?.first as! UIView
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        TranslatedView.originLanguage = originLanguage
        TranslatedView.translatedLanguage = translatedLanguage
        TranslatedView.translateText = translateText
        TranslatedView.translatedText = translatedText
    }
    override func layoutSubviews() {
        if originLanguageLabel != nil{
            self.originLanguageLabel.text = TranslatedView.originLanguage
            self.translateTextLabel.text = TranslatedView.translateText
            self.translatedLanguageLabel.text = TranslatedView.translatedLanguage
            self.translatedTextLabel.text = TranslatedView.translatedText
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
