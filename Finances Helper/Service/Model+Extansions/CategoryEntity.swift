//
//  CategoryEntity.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData
import SwiftUI

extension CategoryEntity{
    
  
    
    var wrappedSubcategories: Set<CategoryEntity> {
        get { (subcategories as? Set<CategoryEntity>) ?? [] }
        set { subcategories = newValue as NSSet }
    }
    
    var wrappedColor: Color{
        guard let color else { return .blue }
        return Color(hex: color)
    }
    
    var slice: SliceCategory?{
        guard let id = id else { return nil}
        return .init(id: id, title: title ?? "no name", color: wrappedColor)
    }
    
    static func request() -> NSFetchRequest<CategoryEntity>{
        let fetchRequest = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: true)]
        return fetchRequest
    }
    
    static func create(
        context: NSManagedObjectContext,
        forAccount: AccountEntity,
        title: String,
        color: String,
        subcategories: Set<CategoryEntity>?
    ){
        let category = CategoryEntity(context: context)
        category.id = UUID().uuidString
        category.forAccount = forAccount
        category.color = color
        category.title = title
        if let subcategories{
            category.wrappedSubcategories = subcategories
        }
    }
    
}
