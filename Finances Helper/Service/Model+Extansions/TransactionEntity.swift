//
//  TransactionEntity.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData
import SwiftUI

extension TransactionEntity{
    
    
    var wrappedType: TransactionType{
        .init(rawValue: type ?? "INCOME") ?? .income
    }
    
    var friendlyAmount: String{
        amount.twoNumString + " \(currency?.shortestSymbol ?? "$")"
    }
    
    var currency: Currency?{
        Currency.currency(for: currencyCode ?? "USD")
    }
    
    var wrappedSubcategory: CategoryEntity?{
        category?.wrappedSubcategories.first(where: {$0.id == subcategoryId})
    }
    
    var chartData: ChartData?{
        if let id = category?.id, let categoryTitle = category?.title, let color = category?.wrappedColor{
          return ChartData(id: id, color: color, value: amount, title: categoryTitle, type: wrappedType)
        }
        return nil
    }
    
    
    var sliceValue: SliceValue?{
        if wrappedType == .income, let id = category?.id{
            return .init(categoryId: id, amount: amount)
        }
        return nil
    }
    
    static func fetchRequest(for predicate: NSPredicate) -> NSFetchRequest<TransactionEntity> {
        let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: false),
                                   NSSortDescriptor(key: "amount", ascending: false)]
        let datePredicate = predicate
        request.predicate = datePredicate
        return request
    }
    
    
    static func create(amount: Double,
                       createAt: Date,
                       type: TransactionType,
                       created: UserEntity,
                       account: AccountEntity,
                       category: CategoryEntity,
                       subcategoryId: String?,
                       note: String?,
                       context: NSManagedObjectContext){
        
        let entity = TransactionEntity(context: context)
        entity.id = UUID().uuidString
        entity.amount = amount
        entity.createAt = createAt
        entity.type = type.rawValue
        entity.created = created
        entity.category = category
        entity.subcategoryId = subcategoryId
        entity.forAccount = account
        entity.note = note
        context.saveContext()
    }
    
    static func remove(_ item: TransactionEntity){
        guard let context = item.managedObjectContext else { return }
        context.delete(item)
        context.saveContext()
    }
}


extension NSPredicate{
  static func datePredicate(startDate: Date, endDate: Date)-> Self? {
      NSPredicate(format: "createAt >= %@ AND createAt < %@", startDate as NSDate, endDate as NSDate) as? Self
    }
}

enum TransactionTimeFilter: CaseIterable, Identifiable{
    
    
    static var allCases: [TransactionTimeFilter] = [.day, .week, .month, .year]
    
    var id: String{ title }
    
    case day, week, month, year
    case select(Date)
    
    var title: String{
        switch self {
        case .day: return "Day"
        case .week: return "Week"
        case .month: return "Month"
        case .year: return "Year"
        case .select: return "Select day"
        }
    }
    
    var date: (start: Date?, end: Date?){
        switch self {
        case .day: return (.now.noon, Date().dayAfter)
        case .week: return (Date().getLast7Day(), .now)
        case .month: return (Date().getLast30Day(), .now)
        case .year: return (Date().startOfYear, Date().endOfYear)
        case .select(let date): return (date.noon, date.dayAfter)
        }
    }
    
    var navTitle: String{
        switch self {
        case .day: return Date.now.toFriedlyDate
        case .week: return "Last week"
        case .month: return "Last month"
        case .year: return "Year"
        case .select(let date): return date.toFriedlyDate
        }
    }
}


