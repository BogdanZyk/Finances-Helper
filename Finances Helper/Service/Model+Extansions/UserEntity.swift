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
    
}
