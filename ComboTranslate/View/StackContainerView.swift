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
        removeAllCardViews()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
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
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    func addCardFrame(index: Int, cardView: CardView) {
        var cardViewFrame = bounds
        let horizontalInset = CGFloat(index) * self.horizontalInset
        let verticalInset = CGFloat(index) * self.verticalInset
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        cardView.frame = cardViewFrame
        layoutIfNeeded()
    }
    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
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
            layoutIfNeeded()
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    //self.layoutIfNeeded()
                }
            }
        } else if remainingCards == 0 {
            addCardView(cardView: datasource.emptyView()! as! EmptyView, at: 2)
            layoutIfNeeded()
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    //self.layoutIfNeeded()
                }
            }
        } else {
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    cardView.center = self.center
                    (cardView as? EmptyView)?.labelCount.text = "combo: \(self.correctAnswers)"
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                   // self.layoutIfNeeded()
                }
            }
        }
    }
}
