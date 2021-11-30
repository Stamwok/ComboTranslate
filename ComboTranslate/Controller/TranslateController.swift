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
    @IBOutlet var transLabel: UILabel!
    @IBOutlet var transButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stackViewLanguages: UIView!
    @IBOutlet var backgroundView: UIView!
    
    var opacityView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        translateDataCollection = storage.loadData()
        transField?.delegate = self
        transField!.text = "Введите текст"
        transField?.textColor = UIColor.lightGray
        transField?.font = UIFont(name: transField!.font!.fontName, size: 17)
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
    
    @IBAction func translate() {
        guard var word = transField?.text, word != "" else {
            return
        }
        if word.last == " " {
            word.remove(at: word.index(before: word.endIndex))
        }
        transButton?.isEnabled = false
        var data = TranslateData(words: [word], from: .en, to: .ru)
        self.translateDataCollection.enumerated().forEach { index, transData in
            if transData.words == data.words {
                data = transData
                self.translateDataCollection.remove(at: index)
                return
            }
        }
        translateApi.translate(data: &data) {outputData in
            data = outputData
            self.translateDataCollection.append(data)
            DispatchQueue.main.async {
                self.transLabel?.text = data.translatedWords.reduce("", +)
                self.transButton?.isEnabled = true
            }
        }
    }
    
    func configureOpacityView() {
        backgroundView.addSubview(opacityView)
        opacityView.translatesAutoresizingMaskIntoConstraints = false
        opacityView.topAnchor.constraint(equalTo: transField.bottomAnchor).isActive = true
        opacityView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor).isActive = true
        opacityView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor).isActive = true
        opacityView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        opacityView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    //MARK: - textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
//        self.imageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        self.imageView.constraints.filter{$0.identifier == "imageHeight"}.first?.constant = 0
        opacityView = UIView(frame: backgroundView.frame)
        configureOpacityView()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            transField!.text = "Введите текст"
            transField?.textColor = UIColor.lightGray
        }
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.constraints.filter{$0.identifier == "imageHeight"}.first?.constant = 70
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.opacityView.removeFromSuperview()
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
            translate()
            textView.selectAll(textView)
            textView.resignFirstResponder()
            return false
        }
        return count <= 30
    }
    
    
    
}
