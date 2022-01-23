//
//  WordsPackController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 20.10.21.
//

import UIKit

class WordsPackController: UITableViewController {
    
    var storage = Storage()
    var wordPacks: [TranslateData]!
    
    @IBOutlet var labelCount: UILabel!
    @IBOutlet var labelName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBar1 =  UIView()
        statusBar1.frame = UIApplication.shared.statusBarFrame
        statusBar1.backgroundColor = UIColor.init(hex: "#2E8EEF")
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.keyWindow?.addSubview(statusBar1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wordPacks = storage.loadData()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordsPackCell", for: indexPath)
        (cell.viewWithTag(1) as? UILabel)?.text = "Переведенные слова"
        (cell.viewWithTag(2) as? UILabel)?.text = "Слов \(wordPacks.count)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ToCardsViewSegue" else { return }
        (segue.destination as! CardsViewController).viewModelData = wordPacks
    }
}
