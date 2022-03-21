//
//  ToastMessage.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 21.03.22.
//

import Foundation
import UIKit

class ToastMessage {
    
    static func showMessage(toastWith message: String, view: UIView) {
        
        let frameView = UIView()
        frameView.backgroundColor = .black.withAlphaComponent(0.7)
        frameView.alpha = 1.0
        frameView.layer.cornerRadius = 10
        frameView.clipsToBounds  =  true
        view.addSubview(frameView)
        
        frameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            frameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frameView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            frameView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])
        
        let toast = UILabel()
        toast.numberOfLines = 0
        toast.textColor = .white
        toast.textAlignment = .center
        toast.font = UIFont.systemFont(ofSize: 14)
        toast.text = message
        frameView.addSubview(toast)
        
        toast.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toast.topAnchor.constraint(equalTo: frameView.topAnchor, constant: 10),
            toast.bottomAnchor.constraint(equalTo: frameView.bottomAnchor, constant: -10),
            toast.leftAnchor.constraint(equalTo: frameView.leftAnchor, constant: 10),
            toast.rightAnchor.constraint(equalTo: frameView.rightAnchor, constant: -10)
        ])

        UIView.animate(withDuration: 5, delay: 0.1, options: .curveEaseInOut, animations: {
            frameView.alpha = 0.0
        }, completion: {(_) in
            frameView.removeFromSuperview()
        })
    }
}
