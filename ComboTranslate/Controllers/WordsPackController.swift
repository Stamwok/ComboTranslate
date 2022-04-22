//
//  WordsPackController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 20.10.21.
//

import UIKit

class WordsPackController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var wordPacks: [WordPack] = [] {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wordPacks = StorageWithCDManager.instance.loadWordPacks()
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if wordPacks.count == 0 {
//            tableView.isHidden = true
//            configureMessageLabel()
//        } else {
//            tableView.isHidden = false
//        }
//    }
//    
//    private func configureMessageLabel() {
//        let messageLabel = UILabel()
//        messageLabel.font = UIFont.init(name: "Roboto", size: 17)
//        messageLabel.textColor = .lightGray
//        messageLabel.text = "Нет доступных наборов"
//        messageLabel.textAlignment = .center
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = .white
//        view.addSubview(backgroundView)
//        backgroundView.frame = tableView.frame
//        backgroundView.addSubview(messageLabel)
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            messageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
//            messageLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
//            messageLabel.topAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//        view.layoutIfNeeded()
//    }

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
        if StorageWithCDManager.instance.loadWordsToEditor().count < 7 {
            tableView.cellForRow(at: indexPath)?.isSelected = false
            ToastMessage.showMessage(toastWith: "Для начала изучения добавьте не менее 7 слов", view: self.view)
            return
        }
        guard let words = wordPacks[indexPath.row].words?.allObjects as? [Word] else { return }
        if words.filter({ $0.count < 1.0 }).count < 1 {
            tableView.cellForRow(at: indexPath)?.isSelected = false
            ToastMessage.showMessage(toastWith: "Все слова изучены", view: self.view)
            return
        }
        destination.viewModelData = words
        destination.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WordsPackCell", for: indexPath) as? WordsPackCell else { return UITableViewCell() }
        guard let words = wordPacks[indexPath.row].words?.allObjects as? [Word] else { return UITableViewCell() }
        cell.packName.text = wordPacks[indexPath.row].name
        cell.wordsCount.text = String("Слов: \(words.count)")
        cell.progress.progress = wordPacks[indexPath.row].progress
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
        cell.delegate = self
        if wordPacks[indexPath.row].id == 1 {
            cell.editButton?.isHidden = true
        } else {
            cell.editButton?.isHidden = false
        }
        return cell
    }
}
