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
    
    private var translateApi = GoogleTranslateApi()
    private var storage = Storage()
    private var opacityView: UIView = UIView()
    private var translateView = TranslateView()
    private var translatedView = TranslatedView()
    private var tableView: TranslateTableController?
    private var scrollView: UIScrollView = UIScrollView()
    private var languages: [String] = []
    
    private var originLanguage: String = String() {
        didSet {
            storage.saveOriginLanguage(originLanguage)
            originLanguageButton.setTitle(originLanguage, for: .normal)
        }
    }
    private var translationLanguage: String = String() {
        didSet {
            storage.saveTranslatedLanguage(translationLanguage)
            translatedLanguageButton.setTitle(translationLanguage, for: .normal)
        }
    }
    
    lazy var translateDataCollection: [Word] = [] {
        didSet {
            tableView?.translateDataCollection = translateDataCollection
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = self.children[0] as? TranslateTableController
        GoogleLanguagesList.languages.forEach({ key, _ in
            self.languages.append(key)
        })
        configureShadows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        originLanguage = storage.loadOriginLanguage()
        translationLanguage = storage.loadTranslatedLanguage()
    }
    
    func reloadData() {
        translateDataCollection = StorageWithCDManager.instance.loadWords()
    }
    
    // MARK: - Delegate translateView
    func closeTranslateView() {
        imageView.constraints.filter {$0.identifier == "imageHeight"}.first?.constant = 70
        transFieldView.constraints.filter {$0.identifier == "transFieldViewHeight"}.first?.constant = 128
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        translateView.removeFromSuperview()
        opacityView.removeFromSuperview()
    }
    func setData(data: TranslateData?) {
        guard let data = data else { return }
        let newWord = StorageWithCDManager.instance.addNewWord(word: data)
        self.translateDataCollection.enumerated().forEach { _, transData in
            if transData.word == data.word {
                newWord.count = transData.count
                StorageWithCDManager.instance.removeItem(item: transData)
                return
            }
        }
        StorageWithCDManager.instance.saveContext()
        reloadData()
        
        imageView.constraints.filter {$0.identifier == "imageHeight"}.first?.constant = 70
        transFieldView.constraints.filter {$0.identifier == "transFieldViewHeight"}.first?.constant = 128
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        configureTranslatedView(data: newWord)
        translateView.removeFromSuperview()
        opacityView.removeFromSuperview()
    }
    func translate(text: String, completionHandler: @escaping (TranslateData) -> Void) {
        let data = TranslateData(word: text, from: originLanguage, to: translationLanguage)
        translateApi.translate(data: data) {outputData in
            completionHandler(outputData)
        }
    }
    
    // MARK: - Delegate translatedView
    func closeTranslatedView() {
        transFieldOriginState()
        scrollView.removeFromSuperview()
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
        tabBarController?.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBarController?.tabBar.layer.shadowRadius = 5
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.backgroundImage = UIImage()
    }
    
    private func configureTranslateView() {
        configureOpacityView()
        transFieldView.isHidden = false
        translateView.delegate = self
        translateView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(translateView)
        translateView.heightAnchor.constraint(equalTo: transFieldView.heightAnchor).isActive = true
        translateView.topAnchor.constraint(equalTo: transFieldView.topAnchor).isActive = true
        translateView.leftAnchor.constraint(equalTo: transFieldView.leftAnchor).isActive = true
        translateView.rightAnchor.constraint(equalTo: transFieldView.rightAnchor).isActive = true
    }
    
    func configureTranslatedView(data: Word) {
        containerWithTable.isHidden = true
        transFieldView.isHidden = true
        translatedView.configureTranslatedView(data: data)
        translatedView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        translatedView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(scrollView)
        scrollView.addSubview(translatedView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: transFieldView.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: transFieldView.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: transFieldView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            
            translatedView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            translatedView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            translatedView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            translatedView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        self.scrollView.layoutIfNeeded()
        scrollView.layer.opacity = 0
        UIView.animate(withDuration: 0.3) {
            self.scrollView.layer.opacity = 1
        }
    }
    
    private func configureOpacityView() {
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
        originLanguage = translationLanguage
        translationLanguage = temporaryStorage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "originLanguage" {
            guard let destionation = segue.destination as? LanguagesTableViewController else { return }
            destionation.headerLabelText = "Язык оригинала"
            destionation.languages = self.languages
            destionation.checkMarkOn = originLanguage
            destionation.doAfterLanguageSelected = { [weak self] language in
                if language == self?.translationLanguage {
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
            destionation.checkMarkOn = translationLanguage
            destionation.doAfterLanguageSelected = { [weak self] language in
                if language == self?.originLanguage {
                    self?.switchLanguages()
                } else {
                    self?.translationLanguage = language
                }
                destionation.dismiss(animated: true, completion: nil)
            }
        }
    }
}
