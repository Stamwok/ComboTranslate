//
//  TranslateTableController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 23.09.21.
//

import UIKit

class TranslateTableController: UITableViewController {
    
    // MARK: - initiate
    var translateDataCollection: [Word] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translateDataCollection.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getConfiguredTranslateCell(for: indexPath)
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") {_, _, _ in
            let itemForRemove = self.translateDataCollection.reversed()[indexPath.row]
            StorageWithCDManager.instance.removeItem(item: itemForRemove)
            StorageWithCDManager.instance.saveContext()
            (self.parent as? TranslateController)?.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (self.parent as? TranslateController)?.configureTranslatedView(data: translateDataCollection.reversed()[indexPath.row])
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    private func getConfiguredTranslateCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TranslateCell", for: indexPath) as? TranslateCell
        cell?.translateLabel?.text = translateDataCollection.reversed()[indexPath.row].word
        cell?.translatedLabel?.text = translateDataCollection.reversed()[indexPath.row].translatedWord
        cell?.progress?.progress = translateDataCollection.reversed()[indexPath.row].count
        if indexPath.row + 1 == translateDataCollection.count {
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 400, bottom: 0, right: 0)
        } else {
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
        return cell!
    }
}
