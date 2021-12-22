//
//  TranslateController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 13.09.21.
//

import UIKit

class TranslateController: UIViewController, UITabBarControllerDelegate, UITextViewDelegate {
    
// MARK: - Outlets and initial
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var transField: UITextView!
    @IBOutlet var containerWithTable: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stackViewLanguages: UIView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var originLanguageButton: UIButton!
    @IBOutlet var translatedLanguageButton: UIButton!
    
    var translateApi = IBMTranslateApi()
    var storage = Storage()
    var translatePlaceView: UIView!
    var opacityView: UIView!
    var transFieldHeight: NSLayoutConstraint!
    var transButton: UIButton!
    var translateView: UIView!
    var translatedView: UIView!
    var translateLabel: UILabel!
    var translatedLabel: UILabel!
    var languages: [String] = []
    var originLanguageLabel: UILabel!
    var translatedLanguageLabel: UILabel!
    
    var translateViewHeightAnchor: NSLayoutConstraint!
    var translatedViewHeightAnchor: NSLayoutConstraint!
    
    var originLanguage: String! {
        didSet {
            storage.saveOriginLanguage(originLanguage)
            DispatchQueue.main.async {
                self.originLanguageButton.setTitle(self.originLanguage, for: .normal)
            }
        }
    }
    var translatedLanguage: String! {
        didSet {
            storage.saveTranslatedLanguage(translatedLanguage)
            DispatchQueue.main.async {
                self.translatedLanguageButton.setTitle(self.translatedLanguage, for: .normal)
            }
            
        }
    }
    
    var translateDataCollection: [TranslateData] = [] {
        didSet {
            DispatchQueue.main.async {
                (self.children[0] as? TranslateTableController)?.translateDataCollection = self.translateDataCollection
            }
            storage.saveData(data: translateDataCollection)
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        translateApi.languages.forEach({ key, _ in
            self.languages.append(key)
        })
        tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBarController?.tabBar.layer.shadowOpacity = 0.3
        tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBarController?.tabBar.layer.shadowRadius = 2
        
        closeButton.isHidden = true
        closeButton.clipsToBounds = true
        
//        translateDataCollection = storage.loadData()
        transField?.delegate = self
        transFieldOriginState()
        transField?.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        transField.layer.shadowOpacity = 0.5
        transField.layer.shadowOffset = CGSize(width: 0, height: 2)
        transField.layer.shadowColor = UIColor.black.cgColor
        transField.layer.shadowRadius = 2
        transField.clipsToBounds = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        translateDataCollection = storage.loadData()
        originLanguage = storage.loadOriginLanguage()
        translatedLanguage = storage.loadTranslatedLanguage()
        (self.children[0] as? TranslateTableController)?.translateDataCollection = self.translateDataCollection
    }
    
    func translate(text: String?, sender: UIButton?) {
        guard var word = text, word != "" else {
            return
        }
        if word.last == " " {
            word.remove(at: word.index(before: word.endIndex))
        }
        transButton?.isEnabled = false
        var data = TranslateData(words: [word], from: translateApi.languages[originLanguage]!, to: translateApi.languages[translatedLanguage]!)
        if sender != nil {
            self.translateDataCollection.enumerated().forEach { index, transData in
                if transData.words == data.words {
                    data = transData
                    self.translateDataCollection.remove(at: index)
                    return
                }
            }
        }
        
        translateApi.translate(data: &data) {outputData in
            data = outputData
            if sender != nil {
                self.translateDataCollection.append(data)
                return
            }
            DispatchQueue.main.async {
                if self.transField.text.count > 0 {
                    self.translatedLabel?.text = data.translatedWords.reduce("", +)
                    self.transButton?.isEnabled = true
                }
            }
        }
    }
    
    // MARK: configure views
    @IBAction func closeButton(sender : UIButton?) {
        if let _ = sender, let _ = translatedView {
            transField.text = ""
            translateView.removeFromSuperview()
            translatedView.removeFromSuperview()
            containerWithTable.isHidden = false
        }
        closeButton.isHidden = true
        transFieldOriginState()
        transField.resignFirstResponder()
    }
    
    private func transFieldOriginState() {
        transField.isHidden = false
        transField?.text = "Введите текст"
        transField?.textColor = UIColor.lightGray
        transField?.font = UIFont(name: transField!.font!.fontName, size: 20)
        closeButton.isHidden = true
    }
    
    func configureOpacityView() {
        backgroundView.addSubview(opacityView)
        opacityView.translatesAutoresizingMaskIntoConstraints = false
        opacityView.topAnchor.constraint(equalTo: translatePlaceView.bottomAnchor).isActive = true
        opacityView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor).isActive = true
        opacityView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor).isActive = true
        opacityView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        opacityView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        opacityView.isUserInteractionEnabled = true
        opacityView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dropKeyboard)))
        opacityView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dropKeyboard)))
    }
    
    @objc func dropKeyboard (_ : Any) {
        transField.resignFirstResponder()
    }
    
    func configureTranslatePlaceView() {
        transFieldHeight = self.transField.constraints.filter {$0.identifier == "transFieldHeight"}.first
        transFieldHeight?.constant = transFieldHeight!.constant / 1.5
        translatePlaceView = UIView()
        translatePlaceView.backgroundColor = .white
        backgroundView.addSubview(translatePlaceView)
        
        translatePlaceView.translatesAutoresizingMaskIntoConstraints = false
        translatePlaceView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor).isActive = true
        translatePlaceView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor).isActive = true
        translatePlaceView.topAnchor.constraint(equalTo: transField.bottomAnchor, constant: 1).isActive = true
        translatePlaceView.heightAnchor.constraint(equalToConstant: transFieldHeight!.constant).isActive = true
        
        transButton = UIButton()
        let buttonImage = UIImage(systemName: "arrow.right.circle.fill")?.withRenderingMode(.alwaysTemplate)
        transButton.setImage(buttonImage, for: .normal)
        transButton.tintColor = UIColor(hex: "#2E8EEF")
        transButton.contentVerticalAlignment = .fill
        transButton.contentHorizontalAlignment = .fill
        translatePlaceView.addSubview(transButton)
        if transField.text.count == 0 {
            transButton.isEnabled = false
        }
        transButton.addTarget(self, action: #selector(translateButtonAction), for: .touchUpInside)
        transButton.accessibilityIdentifier = "translateButton"
        transButton.translatesAutoresizingMaskIntoConstraints = false
        transButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        transButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        transButton.rightAnchor.constraint(equalTo: translatePlaceView.rightAnchor, constant: -10).isActive = true
        transButton.centerYAnchor.constraint(equalTo: translatePlaceView.centerYAnchor).isActive = true
        
        translatedLabel = UILabel()
        translatePlaceView.addSubview(translatedLabel)
        translatedLabel.translatesAutoresizingMaskIntoConstraints = false
        translatedLabel.centerYAnchor.constraint(equalTo: translatePlaceView.centerYAnchor).isActive = true
        translatedLabel.leftAnchor.constraint(equalTo: translatePlaceView.leftAnchor, constant: 10).isActive = true
        translatedLabel.textColor = UIColor(hex: "#2E8EEF")
        translatedLabel.text = transField.text ?? ""
        translatePlaceView.layoutSubviews()
    }
    @objc func translateButtonAction(sender: UIButton) {
        translate(text: transField.text!, sender: sender)
        configureTranslatedView()
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.layoutSubviews()
        }
        transField.resignFirstResponder()
    }
    
    func configureTranslatedView() {
        containerWithTable.isHidden = true
        transField.isHidden = true
        
        translateView = UIView()
        translateView.backgroundColor = .white
        translateView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(translateView)
        translateView.topAnchor.constraint(equalTo: stackViewLanguages.bottomAnchor, constant: 2).isActive = true
        translateView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor).isActive = true
        translateView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor).isActive = true
        
        let closeButton2 = UIButton()
        let imageForButton = UIImage(systemName: "xmark")
        closeButton2.setImage(imageForButton, for: .normal)
        closeButton2.tintColor = .lightGray
        translateView.addSubview(closeButton2)
        closeButton2.translatesAutoresizingMaskIntoConstraints = false
        closeButton2.widthAnchor.constraint(equalToConstant: 51).isActive = true
        closeButton2.heightAnchor.constraint(equalToConstant: 41).isActive = true
        closeButton2.rightAnchor.constraint(equalTo: translateView.rightAnchor).isActive = true
        closeButton2.topAnchor.constraint(equalTo: translateView.topAnchor).isActive = true
        closeButton2.addTarget(self, action: #selector(dropTranslatedView), for: .touchUpInside)
        
        originLanguageLabel = UILabel()
        originLanguageLabel.text = originLanguage
        originLanguageLabel.textColor = .lightGray
        translateView.addSubview(originLanguageLabel)
        originLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        originLanguageLabel.topAnchor.constraint(equalTo: translateView.topAnchor, constant: 10).isActive = true
        originLanguageLabel.leftAnchor.constraint(equalTo: translateView.leftAnchor, constant: 10).isActive = true
        
        translateLabel = UILabel()
        translateLabel.text = transField.text
        translateLabel.textColor = .black
        translateView.addSubview(translateLabel)
        translateLabel.translatesAutoresizingMaskIntoConstraints = false
        translateLabel.leftAnchor.constraint(equalTo: translateView.leftAnchor, constant: 10).isActive = true
        translateLabel.centerYAnchor.constraint(equalTo: translateView.centerYAnchor).isActive = true
        
        translatedView = UIView()
        translatedView.backgroundColor = UIColor(hex: "#2E8EEF")
        translatedView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(translatedView)
        
        translatedView.topAnchor.constraint(equalTo: translateView.bottomAnchor, constant: 10).isActive = true
        translatedView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -10).isActive = true
        translatedView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 10).isActive = true
        
        translatedLanguageLabel = UILabel()
        translatedLanguageLabel.textColor = .white
        translatedLanguageLabel.text = translatedLanguage
        translatedView.addSubview(translatedLanguageLabel)
        translatedLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        translatedLanguageLabel.topAnchor.constraint(equalTo: translatedView.topAnchor, constant: 10).isActive = true
        translatedLanguageLabel.leftAnchor.constraint(equalTo: translatedView.leftAnchor, constant: 10).isActive = true
        
        translatedView.addSubview(translatedLabel)
        translatedLabel.textColor = .white
        translatedLabel.translatesAutoresizingMaskIntoConstraints = false
        translatedLabel.centerYAnchor.constraint(equalTo: translatedView.centerYAnchor).isActive = true
        translatedLabel.leftAnchor.constraint(equalTo: translatedView.leftAnchor, constant: 10).isActive = true
        
        backgroundView.layoutIfNeeded()
        translateViewHeightAnchor = translateView.heightAnchor.constraint(equalTo: translateView.widthAnchor, multiplier: 1.0 / 2.0)
        translatedViewHeightAnchor = translatedView.heightAnchor.constraint(equalTo: translateView.heightAnchor)
        translateViewHeightAnchor.isActive = true
        translatedViewHeightAnchor.isActive = true
    }
    @objc func dropTranslatedView() {
        translateViewHeightAnchor.isActive = false
        translatedViewHeightAnchor.isActive = false
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.layoutIfNeeded()
        }, completion: { bool in
            if bool {
                self.translateView.removeFromSuperview()
                self.translatedView.removeFromSuperview()
                self.transField.isHidden = false
                self.containerWithTable.isHidden = false
                self.transFieldOriginState()
            }
            
        })
        
        
    }
    
    // MARK: - textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
            
        }
        closeButton.isHidden = false
        self.imageView.constraints.filter {$0.identifier == "imageHeight"}.first?.constant = 0
        opacityView = UIView(frame: backgroundView.frame)
        configureTranslatePlaceView()
        configureOpacityView()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            transFieldOriginState()
        }
//        closeButton.isHidden = true
        transField.resignFirstResponder()
        
        self.imageView.constraints.filter {$0.identifier == "imageHeight"}.first?.constant = 70
        transFieldHeight.constant *= 1.5
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.opacityView.removeFromSuperview()
            self.translatePlaceView.removeFromSuperview()
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textFieldText = textView.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                  return false
              }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + text.count
        
        if text == "\n" {
            textView.selectAll(textView)
            textView.resignFirstResponder()
            return false
        }
        
        if text.count == 0 && range.length > 0 {
            translatedLabel.text = ""
            return true
        } else {
            return count <= 30
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let textFieldText = textView.text else { return }
        translate(text: "\(textFieldText)", sender: nil)
        if textFieldText.count > 0 {
            transButton.isEnabled = true
        } else {
            transButton.isEnabled = false
        }
    }
    
    // MARK: language select
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "originLanguage" {
            guard let destionation = segue.destination as? LanguagesTableViewController else { return }
            destionation.headerLabelText = "Язык оригинала"
            destionation.languages = self.languages
            destionation.checkMarkOn = originLanguage
            destionation.doAfterLanguageSelected = { language in
                self.originLanguage = language
                destionation.dismiss(animated: true, completion: nil)
            }
        }
        if segue.identifier == "translatedLanguage" {
            guard let destionation = segue.destination as? LanguagesTableViewController else { return }
            destionation.headerLabelText = "Перевести на"
            destionation.languages = self.languages
            destionation.checkMarkOn = translatedLanguage
            destionation.doAfterLanguageSelected = { language in
                self.translatedLanguage = language
                destionation.dismiss(animated: true, completion: nil)
            }
        }
    }
}
