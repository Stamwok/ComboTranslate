//
//  EditorViewController.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 10.02.22.
//

import UIKit

class EditorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var dataSource: [Word] = StorageWithCDManager.instance.loadWords()
    var wordPack: WordPack?
    let edgeInset: CGFloat = 8
    let minSpacing: CGFloat = 8
    var completionHandler: (() -> Void)?
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var deleteButton: UIButton!
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
        deleteButton.layer.cornerRadius = 15
//        dataSource = Storage().loadData().reversed()
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
    
    // MARK: - collectionView layout flow
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellSize = CGSize(width: 100, height: 30)
//        return cellSize
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let itemSize: CGSize! = (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize
//        let spacing: CGFloat! = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing
//        let itemsCount = CGFloat(collectionView.numberOfItems(inSection: section))
//        print(itemSize)
//        print(itemsCount)
//        let edgeInset: CGFloat = collectionView.bounds.width - itemSize.width * 3 - spacing * (3 - 1.0)
//        let resultEdge = max(edgeInset/2, 8)
//        return UIEdgeInsets(top: 8, left: resultEdge, bottom: 8, right: resultEdge)
//    }
}

class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        // Copy each item to prevent "UICollectionViewFlowLayout has cached frame mismatch" warning
        guard let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        
        // Constants
        let leftPadding: CGFloat = 8
        let interItemSpacing = minimumInteritemSpacing
        
        // Tracking values
        var leftMargin: CGFloat = leftPadding // Modified to determine origin.x for each item
        var maxY: CGFloat = -1.0 // Modified to determine origin.y for each item
        var rowSizes: [[CGFloat]] = [] // Tracks the starting and ending x-values for the first and last item in the row
        var currentRow: Int = 0 // Tracks the current row
        attributes.forEach { layoutAttribute in
            
            // Each layoutAttribute represents its own item
            if layoutAttribute.frame.origin.y >= maxY {
                
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                
                // Register its origin.x in rowSizes for use later
                if rowSizes.count == 0 {
                    // Add to first row
                    rowSizes = [[leftMargin, 0]]
                } else {
                    // Append a new row
                    rowSizes.append([leftMargin, 0])
                    currentRow += 1
                }
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
            
            // Add right-most x value for last item in the row
            rowSizes[currentRow][1] = leftMargin - interItemSpacing
        }
        
        // At this point, all cells are left aligned
        // Reset tracking values and add extra left padding to center align entire row
        leftMargin = leftPadding
        maxY = -1.0
        currentRow = 0
        attributes.forEach { layoutAttribute in
            
            // Each layoutAttribute is its own item
            if layoutAttribute.frame.origin.y >= maxY {
                
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                
                // Need to bump it up by an appended margin
                let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0] // last.x - first.x
                let appendedMargin = (collectionView!.frame.width - leftPadding  - rowWidth - leftPadding) / 2
                leftMargin += appendedMargin
                
                currentRow += 1
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
