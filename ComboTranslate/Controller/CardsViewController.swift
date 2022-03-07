//
//  CarsController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 30.09.21.
//

import UIKit

class CardsViewController: UIViewController {
    @IBAction func cancelButton() {
        navigationController?.popViewController(animated: true)
    }
    let storage = Storage()
    var viewModelData: [Word]!
    var stackContainer: StackContainerView!
    var cardsDataModel: [SecretValue] = []
    
    var game: CardsGame!
    // MARK: - Init
    override func loadView() {
        super.loadView()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        configureStackContainer()
        cardsDataModel = generateDataForCards()
        stackContainer.dataSource = self
//        let statusBar1 =  UIView()
//        statusBar1.frame = UIApplication.shared.statusBarFrame
//        statusBar1.backgroundColor = UIColor.init(hex: "#2E8EEF")
//        UIApplication.shared.statusBarStyle = .lightContent
//        UIApplication.shared.keyWindow?.addSubview(statusBar1)
        
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
        card.dataSource = CardsGame(collection: viewModelData, value: cardsDataModel[index]) { dataSource in
            StorageWithCDManager.instance.saveContext()
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
                return value.secretValue!.word == newRandValue.word
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
