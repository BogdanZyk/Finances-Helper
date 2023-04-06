//
//  ResourceStore.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData
import Combine

class ResourceStore<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    
    var resources = CurrentValueSubject<[T], Never>([])
    let context: NSManagedObjectContext
    var frc: NSFetchedResultsController<T>?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        self.frc = nil
    }
    
    func fetch(_ request: NSFetchRequest<T>) {
        self.frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.frc?.delegate = self
        do {
            try self.frc?.performFetch()
            guard let fetchedResources = frc?.fetchedObjects else { return }
            self.resources.value = fetchedResources
        } catch {
            print("Failed to fetch objects: \(error)")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let fetchedResources = controller.fetchedObjects as? [T] else {
            return
        }
        self.resources.value = fetchedResources
    }
}

