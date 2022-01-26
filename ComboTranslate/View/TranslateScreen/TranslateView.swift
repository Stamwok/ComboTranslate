//
//  TranslateView.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 14.01.22.
//

import Foundation
import UIKit

class TranslateView: UIView, UITextViewDelegate {
    
    // MARK: - init and outlets
    weak var delegate: TranslateViewDelegate?
    var translateData: TranslateData? {
        didSet {
            translatedField.text = translateData?.translatedWords
        }
    }

    @IBOutlet var translateField: UITextView!
    @IBOutlet var translatedField: UILabel!
    @IBOutlet var translateButton: UIButton!
    
    @IBAction func closeButton(sender: UIButton) {
        delegate?.closeTranslateView()
    }
    @IBAction func translateButton(sender: UIButton) {
        delegate?.setData(data: translateData)
        
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        let contentView = Bundle.main.loadNibNamed("TranslateView", owner: self, options: nil)?[0] as! UIView
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if translateField != nil {
            translateField.text = "   "
            translateField.becomeFirstResponder()
        }
    }
    
    // MARK: - private metods
    private func updateTranslatedView () {
        delegate?.translate(text: translateField.text.trimmingCharacters(in: .whitespaces)) { [weak self] translated in
            DispatchQueue.main.async { [weak self] in
                if self?.translateField.text != "" {
                    self?.translateData = translated
                }
            }
        }
    }
    
    // MARK: - textViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        guard let textFieldText = textView.text else { return }
        if textFieldText == "" {
            translatedField.text = ""
        }
        updateTranslatedView()
        if textFieldText.count > 0 {
            translateButton.isEnabled = true
        } else {
            translateButton.isEnabled = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        translateField.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textFieldText = textView.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                  return false
              }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + text.count
        
        if text == "\n" {
            delegate?.setData(data: translateData)
            textView.resignFirstResponder()
            return false
        } else if textView.text == "   " && text == "" && range.length > 0 {
            return false
        } else {
            return count <= 30
        }
    }
}
