//
//  CarsController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 30.09.21.
//

import UIKit

class CardsViewController: UIViewController {
    @IBAction func cancelButton(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet var cancelButton: UIButton!
    var viewModelData: [Word]?
    private var stackContainer = StackContainerView()
    private var cardsDataModel: [SecretValue] = []
    
    // MARK: - Init
    override func loadView() {
        super.loadView()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.layer.shadowRadius = 2
        cancelButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        cancelButton.layer.shadowOpacity = 0.5
//        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        configureStackContainer()
        cardsDataModel = generateDataForCards()
        stackContainer.dataSource = self
    }
    func configureStackContainer() {
        let widthStackContainer = view.frame.size.width - 40
        let heightStackContainer = view.frame.size.height - 200
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.widthAnchor.constraint(equalToConstant: widthStackContainer).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: heightStackContainer).isActive = true
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
        view.layoutIfNeeded()
    }
}

extension CardsViewController: SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int {
        return cardsDataModel.count
    }
    func card(at index: Int) -> CardView {
        let card = CardView()
        card.dataSource = CardsGame(collection: StorageWithCDManager.instance.loadWordsToEditor(), value: cardsDataModel[index]) { _ in
            StorageWithCDManager.instance.saveContext()
        }
        return card
    }
    func emptyView() -> UIView? {
        let view = EmptyView()
        return view
    }

    private func generateDataForCards () -> [SecretValue] {
        guard let viewModelData = viewModelData else { return [] }
        var dataForCard: [SecretValue] = []
        var randomIndex: Int {
            get {
                return Array(0...viewModelData.count - 1).randomElement()!
            }
        }
        var wordsNotLearnedNumber: Int {
            return viewModelData.filter({$0.count < 1.0 }).count
        }
        while dataForCard.count < min(6, wordsNotLearnedNumber) {
            let newRandomIndex = randomIndex
            let newRandValue = viewModelData[newRandomIndex]
            let coinsidenceCount = dataForCard.filter({ value in
                return value.secretValue!.word == newRandValue.word
            }).count
            if coinsidenceCount < 1 && newRandValue.count < 1.0 {
                guard var newValue = SecretValue(collection: [newRandValue]) else { return [] }
                newValue.secretValueIndex = newRandomIndex
                dataForCard.append(newValue)
            }
        }
        return dataForCard
    }
}
