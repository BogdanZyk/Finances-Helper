//
//  AccountStore.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 05.04.2023.
//

import Foundation
import CoreData
import Combine

class AccountStore: NSObject {
    
    var accounts = CurrentValueSubject<[AccountEntity], Never>([])
    let context: NSManagedObjectContext
    var frc: NSFetchedResultsController<AccountEntity>?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        self.frc = nil
    }
    
    func fetch(id: String? = nil) {
        let fetchRequest = id != nil ? AccountEntity.request(for: id!) : AccountEntity.requestAll()
        self.frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.frc?.delegate = self
        do {
            try self.frc?.performFetch()
            guard let groups = frc?.fetchedObjects else { return }
            self.accounts.value = groups
        } catch {
            print("Failed to fetch objects: \(error)")
        }
    }
    
}

extension AccountStore: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let accounts = controller.fetchedObjects as? [AccountEntity] else {
            return
        }
        self.accounts.value = accounts
        
    }
}
