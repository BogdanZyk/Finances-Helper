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
    
    var slice: SliceCategory?{
        guard let id = id else { return nil}
        return .init(id: id, title: title ?? "", color: Color.green)
    }
    
    static func request() -> NSFetchRequest<CategoryEntity>{
        let fetchRequest = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: true)]
        return fetchRequest
    }
    
}
