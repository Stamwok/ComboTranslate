//
//  StorageWithCDManager.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 26.01.22.
//

import Foundation
import CoreData

class StorageWithCDManager {
    func getContext(containerName: String) -> NSManagedObjectContext {
        let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: containerName)
            container.loadPersistentStores(completionHandler: { (storePersistent, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        let context: NSManagedObjectContext = {
            return persistentContainer.viewContext
        }()
        return context
    }
//    func saveContext() {
//        var wordPacks = WordPack(self.getContext(containerName: "WordPack"))
//    }
}
