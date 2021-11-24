//
//  CarsController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 30.09.21.
//

import UIKit

class CardsViewController: UIViewController {
   // var correctAnswers: Int = 0
    let storage = Storage()
    var viewModelData: [TranslateData] = [] {
        didSet {
            storage.saveData(data: viewModelData)
        }
    }
    var stackContainer: StackContainerView!
    var cardsDataModel: [SecretValue] = []
    
    var game: CardsGame!
    // MARK: - Init
    override func loadView() {
        super.loadView()
       // guard viewModelData.count > 10 else { return }
//        view = UIView()
//        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        configureStackContainer()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelData = storage.loadData()
        cardsDataModel = generateDataForCards()
        stackContainer.dataSource = self
        
    }
    func configureStackContainer() {
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
}

extension CardsViewController: SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int {
        return cardsDataModel.count
    }
    func card(at index: Int) -> CardView {
        let card = CardView()
        //print(cardsDataModel[index])
        card.dataSource = CardsGame(collection: viewModelData, value: cardsDataModel[index]) {dataSource in
            self.viewModelData[dataSource.secretValueIndex] = dataSource.secretValue
        }
        return card
    }
    func emptyView() -> UIView? {
        let view = EmptyView()
        return view
    }

    private func generateDataForCards () -> [SecretValue] {
        var dataForCard: [SecretValue] = []
        var randomIndex: Int {
            get {
                return Array(0...viewModelData.count - 1).randomElement()!
            }
        }
        while dataForCard.count < 6 {
            let newRandomIndex = randomIndex
            let newRandValue = viewModelData[newRandomIndex]
            let coinsidenceCount = dataForCard.filter({ value in
                return value.secretValue!.words == newRandValue.words
            }).count
            if coinsidenceCount < 1 && newRandValue.count < 1.0 {
                var newValue = SecretValue(collection: [newRandValue])
                newValue?.secretValueIndex = newRandomIndex
                dataForCard.append(newValue!)
            }
        }
        return dataForCard
    }
}
