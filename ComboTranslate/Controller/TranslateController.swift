//
//  TranslateController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 13.09.21.
//

import UIKit

class TranslateController: UIViewController {
    var translateApi = IBMTranslateApi()
    var storage = Storage()
    var translateDataCollection: [TranslateData] = [] {
        didSet {
            DispatchQueue.main.async {
                (self.children[0] as? TranslateTableController)?.translateDataCollection = self.translateDataCollection
                (self.children[0] as? TranslateTableController)?.tableView.reloadData()
            }
            storage.saveData(data: translateDataCollection)
        }
    }
// MARK: - Outlets
    @IBOutlet var transField: UITextField?
    @IBOutlet var transLabel: UILabel?
    @IBOutlet var transButton: UIButton?
    @IBAction func textFieldShouldReturn(_ textField: UITextField) {
         translate()
    }
    @IBAction func translate() {
        guard let word = transField?.text, word != "" else {
            return
        }
        transButton?.isEnabled = false
        var data = TranslateData(words: [word], from: .en, to: .ru)
        translateApi.translate(data: &data) {outputData in
            data = outputData
            self.translateDataCollection.append(data)
            DispatchQueue.main.async {
                self.transLabel?.text = data.translatedWords[0]
                self.transButton?.isEnabled = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        translateDataCollection = storage.loadData()
        (self.children[0] as? TranslateTableController)?.translateDataCollection = self.translateDataCollection
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InfoSegue"{
            let infoTabVC = segue.destination as? TranslateTableController
            infoTabVC?.translateDataCollection = self.translateDataCollection
        }
    }
}
