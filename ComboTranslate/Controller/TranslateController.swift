//
//  TranslateController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 13.09.21.
//

import UIKit

class TranslateController: UIViewController, UITabBarControllerDelegate, UITextViewDelegate {
    var translateApi = IBMTranslateApi()
    var storage = Storage()
    var translateDataCollection: [TranslateData] = [] {
        didSet {
            DispatchQueue.main.async {
                (self.children[0] as? TranslateTableController)?.translateDataCollection = self.translateDataCollection
            }
            storage.saveData(data: translateDataCollection)
        }
    }
// MARK: - Outlets and initial
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var transField: UITextView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stackViewLanguages: UIView!
    @IBOutlet var backgroundView: UIView!
    
    var translatePlaceView: UIView!
    var opacityView: UIView!
    var transFieldHeight: NSLayoutConstraint!
    var transButton: UIButton!
    var closeButton: UIButton!
    var translateView: UIView!
    var transLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBarController?.tabBar.layer.shadowOpacity = 0.3
        tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBarController?.tabBar.layer.shadowRadius = 2
        
        translateDataCollection = storage.loadData()
        transField?.delegate = self
        transField!.text = "Введите текст"
        transField?.textColor = UIColor.lightGray
        transField?.font = UIFont(name: transField!.font!.fontName, size: 20)
        transField?.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        transField.layer.shadowOpacity = 0.5
        transField.layer.shadowOffset = CGSize(width: 0, height: 2)
        transField.layer.shadowColor = UIColor.black.cgColor
        transField.layer.shadowRadius = 2
        transField.clipsToBounds = false
        
//        stackViewLanguages.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        translateDataCollection = storage.loadData()
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
        var data = TranslateData(words: [word], from: .en, to: .ru)
        if let _ = sender {
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
            if let _ = sender {
                self.translateDataCollection.append(data)
//                self.transField.resignFirstResponder()
                return
            }
            DispatchQueue.main.async {
                if self.transField.text.count > 0 {
                    self.transLabel?.text = data.translatedWords.reduce("", +)
                    self.transButton?.isEnabled = true
                }
            }
        }
    }
    
    @objc func translateButtonAction(sender: UIButton) {
        guard sender.accessibilityIdentifier == "translateButton" else { return }
        translate(text: transField.text!, sender: sender)
        transField.resignFirstResponder()
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
//        transButton.setTitle("Перевод", for: .normal)
        let buttonImage = UIImage(systemName: "arrow.right.circle.fill")?.withRenderingMode(.alwaysTemplate)
        transButton.setImage(buttonImage, for: .normal)
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
//        transButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -5).isActive = true
        transButton.centerYAnchor.constraint(equalTo: translatePlaceView.centerYAnchor).isActive = true
        
        transLabel = UILabel()
        translatePlaceView.addSubview(transLabel)
        transLabel.translatesAutoresizingMaskIntoConstraints = false
        transLabel.centerYAnchor.constraint(equalTo: translatePlaceView.centerYAnchor).isActive = true
        transLabel.leftAnchor.constraint(equalTo: translatePlaceView.leftAnchor, constant: 10).isActive = true
        transLabel.textColor = .lightGray
        transLabel.text = transField.text ?? ""
        translatePlaceView.layoutSubviews()
    }
    
    // MARK: - textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
            
        }
//        textView.select(textView)
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
            transField!.text = "Введите текст"
            transField?.textColor = UIColor.lightGray
//            transButton.isEnabled = false
        }
//        imageView.translatesAutoresizingMaskIntoConstraints = false
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
//        transButton.isEnabled = false
//        let textFieldText = textView.text!
//        let rangeOfTextToReplace = Range(range, in: textFieldText)!
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + text.count
        
        if text == "\n" {
            textView.selectAll(textView)
            textView.resignFirstResponder()
            return false
        }
        
        if text.count == 0 && range.length > 0 {
            transLabel.text = ""
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
}
