//
//  StackContainerView.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 7.10.21.
//

import UIKit

class StackContainerView: UIView, SwipeCardsDelegate {
    
    // MARK: - Properties
    private var numberOfCardsToShow: Int = 0
    private var cardsBeToVisible: Int = 3
    private var cardViews: [CardView] = []
    private var remainingCards: Int = 0
    private let horizontalInset: CGFloat = 10.0
    private let verticalInset: CGFloat = 10.0
    private var correctAnswers = 0
    private var visibleCards: [CardView] {
        return subviews as? [CardView] ?? []
    }
    var dataSource: SwipeCardsDataSource? {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reloadData() {
        guard let datasource = dataSource else { return }
        layoutIfNeeded()
        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingCards = numberOfCardsToShow
        for num in 0..<min(numberOfCardsToShow, cardsBeToVisible) {
            addCardView(cardView: datasource.card(at: num), at: num)
        }
    }
    // MARK: - Configurations
    
    private func configureCountLabels(card: CardView, index: Int) {
        card.numberOfCardLabel.text = String(numberOfCardsToShow - remainingCards + 1)
        card.cardCountLabel.text = "/\(numberOfCardsToShow)"
    }
    
    private func addCardView(cardView: CardView, at index: Int) {
        cardView.delegate = self
        if !(cardView is EmptyView) {
            configureCountLabels(card: cardView, index: index)
        }
  
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
        addCardFrame(index: index, cardView: cardView)
    }
    
    private func addCardFrame(index: Int, cardView: CardView) {
        cardView.frame = frame
        let measurements = measurementsForCard(cardView, at: index)
        cardView.frame = measurements.0
        cardView.transform = measurements.1
    }
    
    private func measurementsForCard(_ card: CardView, at index: Int) -> (CGRect, CGAffineTransform) {
        let verticalInset = CGFloat(index) * self.verticalInset
        if index == 2 {
            card.alpha = 0
        }
        UIView.animate(withDuration: 0.5) {
            card.center.y = self.frame.height/2 + 2 * verticalInset
            card.alpha = 1
        }
        card.center.x = self.frame.width/2
        let frame = card.frame
        let coefficient = 1.0 - CGFloat(index) / 20
        let transform = CGAffineTransform(scaleX: coefficient, y: coefficient)
        UIView.animate(withDuration: 0.5) {
            switch index {
            case 0:
                card.contentView.backgroundColor = .white
                card.isUserInteractionEnabled = true
                if let card = card as? EmptyView, let numberOfCards = self.dataSource?.numberOfCardsToShow() {
                    UIView.animate(withDuration: 0.2) {
                        card.circleProgressView.progress = CGFloat(self.correctAnswers) / CGFloat(numberOfCards)
                    }
                }
            case 1:
                card.contentView.backgroundColor = UIColor(hex: "#89BFF7")
                card.isUserInteractionEnabled = false
            case 2:
                card.contentView.backgroundColor = UIColor(hex: "#61ABF7")
                card.isUserInteractionEnabled = false
            default:
                card.contentView.backgroundColor = .white
                card.isUserInteractionEnabled = true
            }
        }
        
        return (frame, transform)
    }
    
    // MARK: - delegate
    func swipeDidEnd(on view: CardView) {
        if view.dataSource!.isGameWin {
            self.correctAnswers += 1
        }
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()
        if remainingCards > 0 {
            let newIndex = datasource.numberOfCardsToShow() - remainingCards
            addCardView(cardView: datasource.card(at: newIndex), at: 2)
                for (cardIndex, cardView) in self.visibleCards.reversed().enumerated() {
                    let measurements = self.measurementsForCard(cardView, at: cardIndex)
                    UIView.animate(withDuration: 0.5) {
                        cardView.frame = measurements.0
                        cardView.transform = measurements.1
                    }
            }
        } else if remainingCards == 0 {
            addCardView(cardView: datasource.emptyView()! as! EmptyView, at: 2)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                let measurements = self.measurementsForCard(cardView, at: cardIndex)
                UIView.animate(withDuration: 0.5) {
                    cardView.frame = measurements.0
                    cardView.transform = measurements.1
                }
            }
        } else {
            for (cardIndex, cardView) in self.visibleCards.reversed().enumerated() {
                let measurements = self.measurementsForCard(cardView, at: cardIndex)
                UIView.animate(withDuration: 0.5) {
                    cardView.frame = measurements.0
                    cardView.transform = measurements.1
                    }
            }
        }
    }
    func swipeDidStart(on view: CardView) {
        guard visibleCards.count > 1 else { return }
        UIView.animate(withDuration: 0.2) {
            self.visibleCards.reversed()[1].contentView.backgroundColor = .white
        }
    }
    
    func swipeDidNotEnded(on view: CardView) {
        guard visibleCards.count > 1 else { return }
        UIView.animate(withDuration: 0.2) {
            self.visibleCards.reversed()[1].contentView.backgroundColor = UIColor(hex: "#89BFF7")
        }
    }
}
