//
//  TranslatedView.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 20.01.22.
//

import UIKit

class TranslatedView: UIView {
    
    weak var delegate: TranslatedViewDelegate?
    
    @IBOutlet var originLanguageLabel: UILabel!
    @IBOutlet var translatedLanguageLabel: UILabel!
    @IBOutlet var translateTextLabel: UILabel!
    @IBOutlet var translatedTextLabel: UILabel!
    @IBAction func closeButton(sender: UIButton) {
        delegate?.closeTranslatedView()
    }
    @IBAction func tapOnTranslateView (sender: UITapGestureRecognizer) {
        delegate?.edit()
    }
    var originLanguage: String?
    var translatedLanguage: String?
    var translateText: String?
    var translatedText: String?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    init?(data: Word) {
        super.init(frame: .zero)
        let contentView = Bundle.main.loadNibNamed("TranslatedView", owner: self, options: nil)?.first as! UIView
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        self.originLanguage = data.originLanguage
        self.translatedLanguage = data.translationLanguage
        self.translateText = data.word
        self.translatedText = data.translatedWord
    }
    override func layoutSubviews() {
        if originLanguageLabel != nil {
            self.originLanguageLabel.text = originLanguage
            self.translateTextLabel.text = translateText
            self.translatedLanguageLabel.text = translatedLanguage
            self.translatedTextLabel.text = translatedText
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
