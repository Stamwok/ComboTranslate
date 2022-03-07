//
//  WordsPackController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 20.10.21.
//

import UIKit

class WordsPackController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var storage = Storage()
    var wordPacks: [WordPack] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    @IBOutlet var tableView: UITableView!
    @IBAction func addPack(_ : UIButton) {
        guard let destination = self.storyboard?.instantiateViewController(withIdentifier: String(describing: EditorViewController.self)) as? EditorViewController else { return }
        destination.completionHandler = {
            self.wordPacks = StorageWithCDManager.instance.loadWordPacks()
        }
        present(destination, animated: true, completion: nil)
        
    }
    
    func editPack(cell: UITableViewCell) {
        guard let destination = self.storyboard?.instantiateViewController(withIdentifier: String(describing: EditorViewController.self)) as? EditorViewController else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        destination.wordPack = wordPacks[indexPath.row]
        destination.completionHandler = {
            self.wordPacks = StorageWithCDManager.instance.loadWordPacks()
        }
        present(destination, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        let statusBar1 =  UIView()
//        statusBar1.frame = UIApplication.shared.statusBarFrame
//        statusBar1.backgroundColor = UIColor.init(hex: "#2E8EEF")
//        UIApplication.shared.statusBarStyle = .lightContent
//        UIApplication.shared.keyWindow?.addSubview(statusBar1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        wordPacks = StorageWithCDManager.instance.loadWordPacks()
        print("viewWillAppear")
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wordPacks.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destination = self.storyboard?.instantiateViewController(withIdentifier: String(describing: CardsViewController.self)) as? CardsViewController else { return }
        guard let words = wordPacks[indexPath.row].words, words.count > 6 else {
            tableView.cellForRow(at: indexPath)?.isSelected = false
            return
        }
        destination.viewModelData = words.allObjects as? [Word]
        destination.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destination, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
//        print(destination.viewModelData)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WordsPackCell", for: indexPath) as? WordsPackCell else { return WordsPackCell() }
        guard let words = wordPacks[indexPath.row].words?.allObjects as? [Word] else { return WordsPackCell() }
        cell.packName.text = wordPacks[indexPath.row].name
        cell.wordsCount.text = String("\(words.count) слов")
        var shortList: String = {
            var resultArr: [String] = []
            for item in words {
                guard let word = item.word else { continue }
                resultArr.append(word)
            }
            
            return resultArr.reduce("", {$0 + ", " + $1})
        }()
        cell.shortList.text = shortList
        cell.delegate = self
        if indexPath.row == 0 {
            cell.editButton.isHidden = true
        }
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "ToCardsViewSegue" else { return }
//        (segue.destination as! CardsViewController).viewModelData = wordPacks
//    }
}
