//
//  CoreData+Extansions.swift
//  Splitify
//
//  Created by Bogdan Zykov on 28.03.2023.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func saveContext (){
        if self.hasChanges {
            do{
                try self.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
