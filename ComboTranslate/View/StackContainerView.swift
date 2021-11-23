//
//  StackContainerView.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 7.10.21.
//

import UIKit

class StackContainerView: UIView, SwipeCardsDelegate {
    
    // MARK: - Properties
    var numberOfCardsToShow: Int = 0
    var cardsBeToVisible: Int = 3
    var cardViews: [CardView] = []
    var remainingCards: Int = 0
    let horizontalInset: CGFloat = 10.0
    let verticalInset: CGFloat = 10.0
    var correctAnswers = 0
    var visibleCards: [CardView] {
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
    
    func reloadData() {
        guard let datasource = dataSource else { return }
        layoutIfNeeded()
        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingCards = numberOfCardsToShow
        for i in 0..<min(numberOfCardsToShow, cardsBeToVisible) {
            addCardView(cardView: datasource.card(at: i), at: i)
        }
    }
    // MARK: - Configurations
    private func addCardView(cardView: CardView, at index: Int) {
        cardView.delegate = self
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
        addCardFrame(index: index, cardView: cardView)
    }
    
    func addCardFrame(index: Int, cardView: CardView) {
        cardView.frame = frame
        let measurements = measurementsForCard(cardView, at: index)
        cardView.frame = measurements.0
        cardView.transform = measurements.1
    }
    
    private func measurementsForCard(_ card: UIView, at index: Int) -> (CGRect, CGAffineTransform) {
        let verticalInset = CGFloat(index) * self.verticalInset
        //var frame = card.frame
        if index == 2{
            card.alpha = 0
        }
        UIView.animate(withDuration: 0.5) {
            
            card.center.y = self.frame.height/2 + 4 * verticalInset
            card.alpha = 1
        }
        card.center.x = self.frame.width/2
        
//        frame.origin.x = frame.width/2
        
//        4 * verticalInset
        let frame = card.frame
        let coefficient = 1.0 - CGFloat(index) / 20
        let transform = CGAffineTransform(scaleX: coefficient, y: coefficient)
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
                    (cardView as? EmptyView)?.labelCount.text = "combo: \(self.correctAnswers)"
                    cardView.frame = measurements.0
                    cardView.transform = measurements.1
                    }
            }
        }
    }
}
