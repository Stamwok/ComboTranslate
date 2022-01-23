//
//  TranslateController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 13.09.21.
//

import UIKit

class TranslateController: UIViewController, UITabBarControllerDelegate, UITextViewDelegate, TranslateViewDelegate, TranslatedViewDelegate {
    
// MARK: - Outlets and initial
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var transFieldView: UIView!
    @IBOutlet var transFieldLabel: UILabel!
    @IBOutlet var containerWithTable: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stackViewLanguages: UIView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var originLanguageButton: UIButton!
    @IBOutlet var translatedLanguageButton: UIButton!
    
    var translateApi = IBMTranslateApi()
    var storage = Storage()
    var opacityView: UIView!
    var translateView: TranslateView!
    var translatedView: TranslatedView!
    var languages: [String] = []
    
    var originLanguage: String! {
        didSet {
            storage.saveOriginLanguage(originLanguage)
            originLanguageButton.setTitle(originLanguage, for: .normal)
        }
    }
    var translatedLanguage: String! {
        didSet {
            storage.saveTranslatedLanguage(translatedLanguage)
            translatedLanguageButton.setTitle(translatedLanguage, for: .normal)
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
        configureShadows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        translateDataCollection = storage.loadData()
        originLanguage = storage.loadOriginLanguage()
        translatedLanguage = storage.loadTranslatedLanguage()
        (self.children[0] as? TranslateTableController)?.translateDataCollection = self.translateDataCollection
    }
    
    // MARK: - Delegate translateView
    func closeTranslateView() {
        imageView.constraints.filter {$0.identifier == "imageHeight"}.first?.constant = 70
        transFieldView.constraints.filter {$0.identifier == "transFieldViewHeight"}.first?.constant = 128
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        translateView?.removeFromSuperview()
        opacityView?.removeFromSuperview()
    }
    func setData(data: TranslateData?) {
        guard var data = data else {
            return
        }
        self.translateDataCollection.enumerated().forEach { index, transData in
            if transData.words == data.words {
                data = transData
                self.translateDataCollection.remove(at: index)
                return
            }
        }
        self.translateDataCollection.append(data)
        
        imageView.constraints.filter {$0.identifier == "imageHeight"}.first?.constant = 70
        transFieldView.constraints.filter {$0.identifier == "transFieldViewHeight"}.first?.constant = 128
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        configureTranslatedView(data: data)
        translateView.removeFromSuperview()
        opacityView.removeFromSuperview()
    }
    func translate(text: String, completionHandler: @escaping (TranslateData) -> Void) {
        var data = TranslateData(words: [text], from: translateApi.languages[originLanguage]!, to: translateApi.languages[translatedLanguage]!)
        translateApi.translate(data: &data) { outputData in
            completionHandler(outputData)
        }
    }
    
    // MARK: - Delegate translatedView
    func closeTranslatedView() {
        transFieldOriginState()
        translatedView?.removeFromSuperview()
    }
    func edit() {
        closeTranslatedView()
        imageView.constraints.filter {$0.identifier == "imageHeight"}.first?.constant = 0
        transFieldView.constraints.filter {$0.identifier == "transFieldViewHeight"}.first?.constant = 170
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        configureTranslateView()
    }
    
    // MARK: actions
//    @IBAction func closeButton(sender: UIButton?) {
//        transFieldOriginState()
//    }
    
    @IBAction func tapOnTranslateFieldView(sender: UITapGestureRecognizer) {
        imageView.constraints.filter {$0.identifier == "imageHeight"}.first?.constant = 0
        transFieldView.constraints.filter {$0.identifier == "transFieldViewHeight"}.first?.constant = 170
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        configureTranslateView()
        
    }
    
    // MARK: - Private metods
    private func transFieldOriginState() {
        transFieldLabel?.text = "Введите текст"
        transFieldLabel?.textColor = UIColor.lightGray
        closeButton.isHidden = true
        transFieldView.isHidden = false
        containerWithTable.isHidden = false
    }
    
    private func configureShadows() {
        closeButton.isHidden = true
        transFieldView.layer.shadowOpacity = 0.5
        transFieldView.layer.shadowOffset = CGSize(width: 0, height: 2)
        transFieldView.layer.shadowColor = UIColor.black.cgColor
        transFieldView.layer.shadowRadius = 2
        transFieldView.clipsToBounds = false
        
        tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBarController?.tabBar.layer.shadowOpacity = 0.3
        tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBarController?.tabBar.layer.shadowRadius = 2
    }
    
    private func configureTranslateView() {
        configureOpacityView()
        transFieldView.isHidden = false
        translateView = TranslateView()
        translateView?.delegate = self
        translateView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(translateView)
        translateView.heightAnchor.constraint(equalTo: transFieldView.heightAnchor).isActive = true
        translateView.topAnchor.constraint(equalTo: transFieldView.topAnchor).isActive = true
        translateView.leftAnchor.constraint(equalTo: transFieldView.leftAnchor).isActive = true
        translateView.rightAnchor.constraint(equalTo: transFieldView.rightAnchor).isActive = true
        translateView.bottomAnchor.constraint(equalTo: transFieldView.bottomAnchor).isActive = true
    }
    
    private func configureTranslatedView(data: TranslateData) {
        transFieldView.isHidden = true
        translatedView = TranslatedView(originLanguage: originLanguage, translateText: data.words.reduce("", +), translatedLanguage: translatedLanguage, translatedText: data.translatedWords.reduce("", +))
        translatedView.delegate = self
        
        translatedView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(translatedView)
        translatedView.topAnchor.constraint(equalTo: transFieldView.topAnchor).isActive = true
        translatedView.leftAnchor.constraint(equalTo: transFieldView.leftAnchor).isActive = true
        translatedView.rightAnchor.constraint(equalTo: transFieldView.rightAnchor).isActive = true
        translatedView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        backgroundView.layoutIfNeeded()
    }
    
    private func configureOpacityView() {
        opacityView = UIView()
        backgroundView.addSubview(opacityView)
        opacityView.translatesAutoresizingMaskIntoConstraints = false
        opacityView.topAnchor.constraint(equalTo: transFieldView.bottomAnchor).isActive = true
        opacityView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor).isActive = true
        opacityView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor).isActive = true
        opacityView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        opacityView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        opacityView.isUserInteractionEnabled = true
        opacityView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dropKeyboard)))
        opacityView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dropKeyboard)))
    }
    @objc func dropKeyboard (_ : Any) {
        closeTranslateView()
    }
    
    // MARK: - language select
    
    @IBAction func switchLanguages() {
        let temporaryStorage = originLanguage
        originLanguage = translatedLanguage
        translatedLanguage = temporaryStorage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "originLanguage" {
            guard let destionation = segue.destination as? LanguagesTableViewController else { return }
            destionation.headerLabelText = "Язык оригинала"
            destionation.languages = self.languages
            destionation.checkMarkOn = originLanguage
            destionation.doAfterLanguageSelected = { [weak self] language in
                if language == self?.translatedLanguage {
                    self?.switchLanguages()
                } else {
                    self?.originLanguage = language
                }
                destionation.dismiss(animated: true, completion: nil)
            }
        }
        if segue.identifier == "translatedLanguage" {
            guard let destionation = segue.destination as? LanguagesTableViewController else { return }
            destionation.headerLabelText = "Перевести на"
            destionation.languages = self.languages
            destionation.checkMarkOn = translatedLanguage
            destionation.doAfterLanguageSelected = { [weak self] language in
                if language == self?.originLanguage {
                    self?.switchLanguages()
                } else {
                    self?.translatedLanguage = language
                }
                destionation.dismiss(animated: true, completion: nil)
            }
        }
    }
}
