//
//  AddWordToPackController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 21.03.22.
//

import UIKit

class AddWordToPackController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var wordPacks: [WordPack] = StorageWithCDManager.instance.loadWordPacks()
    var completionHandler: ((WordPack) -> Void)!
    
    @IBAction func closeButton(_: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        wordPacks.removeFirst()
    }
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordPacks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WordsPackCell", for: indexPath) as? WordsPackCell else { return WordsPackCell() }
        guard let words = wordPacks[indexPath.row].words?.allObjects as? [Word] else { return WordsPackCell() }
        cell.packName.text = wordPacks[indexPath.row].name
        cell.wordsCount.text = String("Слов: \(words.count)")
        
        cell.progress.progress  = wordPacks[indexPath.row].progress
        let shortList: String = {
            var resultArr: [String] = []
            for item in words {
                guard let word = item.word else { continue }
                resultArr.append(word)
            }
            resultArr = resultArr.map({$0 + ", "})
            return resultArr.reduce("", +)
        }()
        cell.shortList.text = shortList
        if wordPacks[indexPath.row].id == 1 {
            cell.editButton?.isHidden = true
        } else {
            cell.editButton?.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completionHandler(wordPacks[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
