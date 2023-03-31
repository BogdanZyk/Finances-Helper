//
//  TransactionStore.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import CoreData
import Combine


class TransactionStore: NSObject {
    
    var transactions = CurrentValueSubject<[TransactionEntity], Never>([])
    let context: NSManagedObjectContext
    var frc: NSFetchedResultsController<TransactionEntity>?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        self.frc = nil
    }
    
    func fetch(for predicate: NSPredicate) {
        let fetchRequest = TransactionEntity.fetchRequest(for: predicate)
        self.frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.frc?.delegate = self
        do {
            try self.frc?.performFetch()
            guard let groups = frc?.fetchedObjects else { return }
            self.transactions.value = groups
        } catch {
            print("Failed to fetch objects: \(error)")
        }
    }
}

extension TransactionStore: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent update")
        guard let groups = controller.fetchedObjects as? [TransactionEntity] else {
            return
        }
        self.transactions.value = groups
        
    }
    

    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        print("didChange 1")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("didChange 2")
    }
}
