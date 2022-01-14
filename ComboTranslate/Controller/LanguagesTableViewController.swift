//
//  LanguagesTableViewController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 13.12.21.
//

import UIKit

class LanguagesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var headerLabel: UILabel!
    @IBAction func dropView() {
        dismiss(animated: true, completion: nil)
    }
    
    var doAfterLanguageSelected: ((String) -> Void)!
    var headerLabelText: String?
    var languages: [String]? = [] {
        didSet {
            languages?.sort {
                $0 < $1
            }
        }
    }
    var checkMarkOn: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = headerLabelText
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return languages!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as? LanguageCell
        cell!.language.text = languages![indexPath.row]
        if cell?.language.text == checkMarkOn {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage: String = languages![indexPath.row]
//        print(selectedLanguage!)
        doAfterLanguageSelected(selectedLanguage)
    }

}
