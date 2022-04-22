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
    private var translateData: TranslateData? {
        didSet {
            guard let newText = translateData?.translatedWord else { return }
            translatedField.text = newText
            if newText.trimmingCharacters(in: .whitespaces).count > 0 {
                translateButton.isEnabled = true
            } else {
                translateButton.isEnabled = false
            }
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
            translateField.becomeFirstResponder()
            translateButton.isEnabled = false
        }
    }
    
    // MARK: - private metods
    private func updateTranslatedView () {
        delegate?.translate(text: translateField.text.trimmingCharacters(in: .whitespaces)) { [weak self] translated in
            DispatchQueue.main.async {
                    self?.translateData = translated
            }
        }
    }
    
    // MARK: - textViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        updateTranslatedView()
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        translateField.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.setData(data: translateData)
            textView.resignFirstResponder()
            return true
        } else {
            return true
        }
    }
}
