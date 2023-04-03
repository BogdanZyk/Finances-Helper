//
//  UserEntity.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData

extension UserEntity{
    
    
    static func create(name: String, context: NSManagedObjectContext) -> UserEntity{
        let user = UserEntity(context: context)
        user.id = UUID().uuidString
        user.name = name
        
        return user
    }
    
    static func request(for id: String) -> NSFetchRequest<UserEntity>{
        let fetchRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        fetchRequest.propertiesToFetch = ["id", "name"]
        return fetchRequest
    }
    
}
