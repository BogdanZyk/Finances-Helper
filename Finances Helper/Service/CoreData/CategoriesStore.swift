//
//  CategoriesStore.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData
import Combine

class CategoriesStore: NSObject {
    
    var categories = CurrentValueSubject<[CategoryEntity], Never>([])
    let context: NSManagedObjectContext
    var frc: NSFetchedResultsController<CategoryEntity>?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        self.frc = nil
    }
    
    func fetch() {
        let fetchRequest = CategoryEntity.request()
        self.frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.frc?.delegate = self
        do {
            try self.frc?.performFetch()
            guard let groups = frc?.fetchedObjects else { return }
            self.categories.value = groups
        } catch {
            print("Failed to fetch objects: \(error)")
        }
    }
}

extension CategoriesStore: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let categories = controller.fetchedObjects as? [CategoryEntity] else {
            return
        }
        self.categories.value = categories
        
    }
}
