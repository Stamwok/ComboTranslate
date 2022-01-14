//
//  TranslateTableController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 23.09.21.
//

import UIKit

class TranslateTableController: UITableViewController {
    var translateDataCollection: [TranslateData] = [] {
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return translateDataCollection.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getConfiguredTranslateCell(for: indexPath)
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") {_, _, _ in
            var newCollection: [TranslateData] = self.translateDataCollection.reversed()
            newCollection.remove(at: indexPath.row)
            (self.parent as? TranslateController)?.translateDataCollection = newCollection.reversed()
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
    private func getConfiguredTranslateCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TranslateCell", for: indexPath) as? TranslateCell
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "TranslateCell") as! TranslateCell
//        cell.contentConfiguration = cell.defaultContentConfiguration()
        cell?.translateLabel?.text = translateDataCollection.reversed()[indexPath.row].words.joined(separator: " ")
        cell?.translatedLabel?.text = translateDataCollection.reversed()[indexPath.row].translatedWords.joined(separator: " ")
        cell?.progress?.progress = translateDataCollection.reversed()[indexPath.row].count
        if indexPath.row + 1 == translateDataCollection.count {
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 400, bottom: 0, right: 0)
        } else {
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
        return cell!
    }
    

//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard indexPath.row == 0 else { return }
//        let degree: Double = 90
//        let rotationAngle = CGFloat(degree * Double.pi / 180)
//        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 0, 0)
//        cell.layer.transform = rotationTransform
//        UIView.animate(withDuration: 1, delay: 0.2 * Double(indexPath.row), options: .curveEaseInOut) {
//            cell.layer.transform = CATransform3DIdentity
//        }
//        let translationTransform = CATransform3DTranslate(CATransform3DIdentity, 400, 0, 0)
//        cell.layer.transform = translationTransform
//
//        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
//            cell.layer.transform = CATransform3DIdentity
//        }
//
//    }
}
