//
//  TranslatedView.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 20.01.22.
//

import UIKit

class TranslatedView: UIView {
    
    weak var delegate: TranslatedViewDelegate?
    
    private var originLanguage: String?
    private var translatedLanguage: String?
    private var translateText: String?
    private var translatedText: String?
    private var word: Word?
    
    @IBOutlet var originLanguageLabel: UILabel!
    @IBOutlet var translatedLanguageLabel: UILabel!
    @IBOutlet var translateTextLabel: UILabel!
    @IBOutlet var translatedTextLabel: UILabel!
    @IBOutlet var translateView: UIView!
    @IBOutlet var translatedView: UIView!
    
    @IBAction func addButton(_: UIButton) {
        guard let view = (delegate as? UIViewController)?.view else { return }
        guard let text = translatedText, text.count < 30 else {
            ToastMessage.showMessage(toastWith: "Фраза слишком длинная", view: view)
            return
        }
        guard let rootController = delegate as? UIViewController else { return }
        guard let destination = rootController.storyboard?.instantiateViewController(withIdentifier: String(describing: AddWordToPackController.self)) as? AddWordToPackController
        else { return }
        guard let word = word else { return }
        destination.completionHandler = { wordPack in
            wordPack.addToWords(word)
            
        }
        rootController.present(destination, animated: true, completion: nil)
    }
    @IBAction func copyButton(_: UIButton) {
        guard let view = (delegate as? UIViewController)?.view else { return }
        UIPasteboard.general.string = translatedText
        ToastMessage.showMessage(toastWith: "Перевод скопирован", view: view)
    }
    @IBAction func shareButton(_: UIButton) {
        guard let rootVC = (delegate as? UIViewController), let textToShare = translatedText else { return }
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = rootVC.view
        
        rootVC.present(activityVC, animated: true, completion: nil)
    }
    @IBAction func closeButton(sender: UIButton) {
        delegate?.closeTranslatedView()
    }
    @IBAction func tapOnTranslateView (sender: UITapGestureRecognizer) {
        delegate?.edit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    init?(data: Word) {
        super.init(frame: .zero)

    }
    
    func configureTranslatedView(data: Word) {
        guard let contentViewFromNib = Bundle.main.loadNibNamed("TranslatedView", owner: self, options: nil)?.first as? UIView else { return }
        let contentView = contentViewFromNib
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
        self.word = data
        
        translatedView.layer.shadowOffset = CGSize(width: 2, height: 2)
        translatedView.layer.shadowOpacity = 0.5
        translatedView.layer.shadowRadius = 2
        
        translateView.layer.shadowOffset = CGSize(width: 0, height: 2)
        translateView.layer.shadowOpacity = 0.5
        translateView.layer.shadowRadius = 2
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
