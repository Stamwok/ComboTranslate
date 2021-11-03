//
//  CardView.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 6.10.21.
//

import UIKit

class CardView: UIView {
    var contentView: UIView!
    var shadowView: UIView!
    @IBOutlet var labelTrans: UILabel?
    @IBOutlet var buttonTrans1: UIButton?
    @IBOutlet var buttonTrans2: UIButton?
    @IBOutlet var buttonTrans3: UIButton?
    @IBOutlet var buttonTrans4: UIButton?
    @IBOutlet var progressBar: UIProgressView?
    
    var buttonCollection: [UIButton?] = []
    var delegate: SwipeCardsDelegate!
    var correctButtonTag: Int?
  //  var game: CardsGame
    var dataSource: CardsGame? {
        didSet {
            
            labelTrans?.text = dataSource?.secretValue.words.reduce("", +)
            progressBar?.progress = Float((dataSource?.secretValue.count)!)
            updateButtons()
        }
    }
    private func updateButtons() {
        correctButtonTag = Array(1...4).randomElement()
        buttonCollection = [buttonTrans1, buttonTrans2, buttonTrans3, buttonTrans4]
        buttonCollection.forEach { button in
            if correctButtonTag == button?.tag {
                button?.setTitle(dataSource?.secretValue.translatedWords.reduce("", +), for: .normal)
            } else {
                let copySeretValue = dataSource?.getNewSecretValue()
                button?.setTitle(copySeretValue?.translatedWords.reduce("", +), for: .normal)
            }
        }
    }
    @IBAction func selectWord (sender: UIButton) {
        if sender.tag != correctButtonTag {
            sender.backgroundColor = .red
            dataSource?.isGameWin = false
        } else if sender.tag == correctButtonTag {
            dataSource?.isGameWin = true
        }
        buttonCollection.forEach {button in
            if button?.tag == correctButtonTag {
                button?.backgroundColor = .green
            }
            button?.isEnabled = false
        }
        if dataSource!.isGameWin {
            progressBar?.progress += 0.25
        } else {
            progressBar?.progress -= 0.25
        }
        dataSource!.closure(dataSource!)
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureShadowView()
        configureCardView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureShadowView() {
        shadowView = UIView()
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 4.0
        addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        shadowView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    func configureCardView() {
        contentView = Bundle.main.loadNibNamed("CardView", owner: self, options: nil)?[0] as? UIView
       // contentView = UIView()
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        shadowView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? CardView else {return}
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        switch sender.state {
        case .ended:
            if(card.center.x) > 300 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            } else if card.center.x < 35 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2 ))
            card.transform = CGAffineTransform(rotationAngle: rotation)
        default:
            break
        }
    }
}
