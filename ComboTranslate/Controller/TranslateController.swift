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
                //(self.children[0] as? TranslateTableController)?.tableView.reloadData()
            }
            storage.saveData(data: translateDataCollection)
        }
    }
// MARK: - Outlets
    @IBOutlet var transField: UITextView?
    @IBOutlet var transLabel: UILabel?
    @IBOutlet var transButton: UIButton?
//    @IBAction func textFieldShouldReturn(_ textField: UITextField) {
//         translate()
//    }
    @IBAction func translate() {
        guard var word = transField?.text, word != "" else {
            return
        }
//        if word.count > 30 {
//            let index = word.index(word.startIndex, offsetBy: 30)
//            word = String(word[..<index])
//        }
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

    override func viewDidLoad() {
        super.viewDidLoad()
        translateDataCollection = storage.loadData()
        transField?.delegate = self
        transField!.text = "Введите текст"
        transField?.textColor = UIColor.lightGray
        transField?.font = UIFont(name: transField!.font!.fontName, size: 17)
        transField?.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        translateDataCollection = storage.loadData()
        (self.children[0] as? TranslateTableController)?.translateDataCollection = self.translateDataCollection
        //(self.children[0] as? TranslateTableController)?.tableView.reloadData()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            transField!.text = "Введите текст"
            transField?.textColor = UIColor.lightGray
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
