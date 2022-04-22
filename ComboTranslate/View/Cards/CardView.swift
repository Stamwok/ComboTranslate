//
//  CardView.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 6.10.21.
//

import UIKit

class CardView: UIView {
    var contentView: UIView = UIView()
    private var shadowView: UIView = UIView()
    @IBOutlet var labelTrans: UILabel!
    @IBOutlet var buttonTrans1: UIButton!
    @IBOutlet var buttonTrans2: UIButton!
    @IBOutlet var buttonTrans3: UIButton!
    @IBOutlet var buttonTrans4: UIButton!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var rectView: UIView!
    @IBOutlet var numberOfCardLabel: UILabel!
    @IBOutlet var cardCountLabel: UILabel!
    @IBOutlet var originLanguage: UILabel!
    @IBOutlet var translationLanguage: UILabel!
    
    private var buttonCollection: [UIButton] = []
    weak var delegate: SwipeCardsDelegate?
    private var correctButtonTag: Int?
    var dataSource: CardsGame? {
        didSet {
            configureProgressView()
            labelTrans.text = dataSource?.secretValue.word
            originLanguage.text = dataSource?.secretValue.originLanguage
            translationLanguage.text = dataSource?.secretValue.translationLanguage
            updateButtons()
        }
    }
    
    private func updateButtons() {
        correctButtonTag = Array(1...4).randomElement()
        buttonCollection = [buttonTrans1, buttonTrans2, buttonTrans3, buttonTrans4]
        buttonCollection.forEach { button in
            if correctButtonTag == button.tag {
                button.setTitle(dataSource?.secretValue.translatedWord, for: .normal)
            } else {
                let copySeretValue = dataSource?.getNewSecretValue()
                button.setTitle(copySeretValue?.translatedWord, for: .normal)
            }
            configureButtonView(button: button)
        }
    }
    
    @IBAction func selectWord (sender: UIButton) {
        if sender.tag != correctButtonTag {
            sender.backgroundColor = ComboColors.red
            sender.setTitleColor(.white, for: .disabled)
            dataSource?.isGameWin = false
        } else if sender.tag == correctButtonTag {
            dataSource?.isGameWin = true
        }
        buttonCollection.forEach {button in
            if button.tag == correctButtonTag {
                button.backgroundColor = ComboColors.green
                button.setTitleColor(.white, for: .disabled)
                
            }
            button.isEnabled = false
        }
        guard let dataSource = dataSource else { return }
        if dataSource.isGameWin {
            progressBar?.progress += 0.25
        } else {
            progressBar?.progress -= 0.25
        }
        
        dataSource.closure(dataSource)
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCardView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - configure views
    private func configureShadowView() {
        shadowView.backgroundColor = .clear
        addSubview(shadowView)
    }
    
    private func configureButtonView(button: UIButton) {
        button.layer.cornerRadius = 15
        button.setTitleColor(.lightGray, for: .disabled)
    }
    
    private func configureProgressView() {
        progressBar.layer.cornerRadius = 15
        progressBar?.progress = Float((dataSource?.secretValue.count)!)
        progressBar?.transform = (progressBar?.transform.scaledBy(x: 1, y: 2))!
    }
    
    private func configureRectView() {
        rectView.layer.cornerRadius = 15
    }
    
    func configureCardView() {
        guard let contentViewFromNib = Bundle.main.loadNibNamed("CardView", owner: self, options: nil)?[0] as? UIView else { return }
        contentView = contentViewFromNib
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
//        labelTrans?.layer.cornerRadius = 15
        configureRectView()
        addSubview(contentView)
       
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    // MARK: - swipe cards logic
    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? CardView else {return}
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        switch sender.state {
        case .began:
            delegate?.swipeDidStart(on: card)
        case .ended:
            if(card.center.x) > 300 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                }
                return
            } else if card.center.x < 35 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = centerOfParentContainer
            }
            self.delegate?.swipeDidNotEnded(on: card)
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2 ))
            card.transform = CGAffineTransform(rotationAngle: rotation)

        default:
            break
        }
    }
}
