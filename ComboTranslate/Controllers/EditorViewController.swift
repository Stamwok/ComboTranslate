//
//  EditorViewController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 10.02.22.
//

import UIKit

class EditorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var dataSource: [Word] = StorageWithCDManager.instance.loadWordsToEditor()
    var wordPack: WordPack?
    let edgeInset: CGFloat = 8
    let minSpacing: CGFloat = 8
    var completionHandler: (() -> Void)?
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var header: UIView!
    @IBAction func acceptPack (_ : UIButton) {
        guard let name = nameField.text, let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        if selectedItems.count != 0 && !name.isEmpty {
            var set: [Word] {
                var result: [Word] = []
                for itemNum in selectedItems {
                    result.append(dataSource[itemNum.row])
                }
                return result
            }
            if wordPack != nil {
                wordPack?.name = nameField.text
                wordPack?.words = NSSet(array: set)
            } else {
                StorageWithCDManager.instance.saveNewPack(name: name, set: set)
            }
            StorageWithCDManager.instance.saveContext()
            completionHandler?()
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func deletePack (_: UIButton) {
        StorageWithCDManager.instance.removeItem(item: wordPack as Any)
        self.dismiss(animated: true)
        completionHandler?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let packName = wordPack?.name {
            nameField.text = packName
        }
        header.layer.shadowOpacity = 0.5
        header.layer.shadowRadius = 2
        header.layer.shadowOffset = CGSize(width: 0, height: 2)
        deleteButton.layer.cornerRadius = 15
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowRadius = 2
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nameField.layer.shadowOpacity = 0.5
        nameField.layer.shadowRadius = 2
        nameField.layer.shadowOffset = CGSize(width: 0, height: 2)
        collectionView.register(EditorCollectionViewCell.nib, forCellWithReuseIdentifier: EditorCollectionViewCell.reuseID)
        let flowLayout = CenterAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = flowLayout
        collectionView.allowsMultipleSelection = true
    }
    
    // MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorCollectionViewCell.reuseID, for: indexPath) as? EditorCollectionViewCell else {
            fatalError("Wrong cell")
        }
        let dataForCell = dataSource[indexPath.row]
        cell.label.text = dataForCell.word
        if let wordPack = wordPack, let words = wordPack.words?.allObjects as? [Word], words.contains(dataForCell) {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
//            }
        }
        cell.clipsToBounds = false
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        deleteButton.isHidden = true
    }
    // MARK: - text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
