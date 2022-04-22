//
//  EditorViewController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 10.02.22.
//

import UIKit

class EditorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIScrollViewDelegate {
    
    var dataSource: [Word] = StorageWithCDManager.instance.loadWordsToEditor()
    var wordPack: WordPack?
    private let edgeInset: CGFloat = 8
    private let minSpacing: CGFloat = 8
    var completionHandler: (() -> Void)?
    private var deleteButtonOriginalFrame: CGRect?
    private var opacityView = UIView()
    private var confirmButton = UIButton()
    private var cancelButton = UIButton()
    
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
        configureOpactityView()
//
    }
    
    @objc func confirmDelete(_ sender: UIButton) {
        StorageWithCDManager.instance.removeItem(item: wordPack as Any)
        self.dismiss(animated: true)
        completionHandler?()
    }
    
    @objc func cancelDelete(_ sender: UIButton) {
        opacityView.removeFromSuperview()
        confirmButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
        deleteButton.isHidden = false
    }
    
    private func configureOpactityView() {
        view.addSubview(opacityView)
        opacityView.translatesAutoresizingMaskIntoConstraints = false
        opacityView.frame = view.frame
        opacityView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.deleteButton.isHidden = true
        
        confirmButton.setImage(UIImage.init(systemName: "trash"), for: .normal)
        confirmButton.tintColor = .white
        confirmButton.backgroundColor = .red
        view.addSubview(confirmButton)
        confirmButton.frame = deleteButton.frame
        confirmButton.frame.size.width = confirmButton.frame.height
        confirmButton.layer.cornerRadius = confirmButton.frame.height / 2
        confirmButton.addTarget(self, action: #selector(confirmDelete), for: .touchUpInside)
        
        cancelButton.setImage(UIImage.init(systemName: "xmark"), for: .normal)
        cancelButton.tintColor = .white
        cancelButton.backgroundColor = .lightGray
        view.addSubview(cancelButton)
        cancelButton.frame = deleteButton.frame
        cancelButton.frame.size.width = cancelButton.frame.height
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        cancelButton.addTarget(self, action: #selector(cancelDelete), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.3) {
            self.confirmButton.center.x = self.view.center.x - self.confirmButton.frame.width / 2 - 10
            self.cancelButton.center.x = self.view.center.x + self.confirmButton.frame.width / 2 + 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if wordPack == nil {
            deleteButton.isHidden = true
        }
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
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = flowLayout
        collectionView.allowsMultipleSelection = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        deleteButtonOriginalFrame = deleteButton.frame
    }
    
    // MARK: - collectionView
    
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
        guard wordPack != nil, let deleteButtonOriginalFrame = deleteButtonOriginalFrame else { return }
        
        let position = scrollView.contentOffset.y
        if position > 0 {
            UIView.animate(withDuration: 0.3) {
                self.deleteButton.frame.origin.y = self.view.frame.maxY
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.deleteButton.frame.origin.y = deleteButtonOriginalFrame.origin.y
            }
        }
    }
    // MARK: - text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
