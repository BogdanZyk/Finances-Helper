//
//  CreateTransactionViewModel.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import Combine
import CoreData
import SwiftUI

class CreateTransactionViewModel: ObservableObject{
    
   
    @Published var transactionType: TransactionType = .expense
    @Published var note: String = ""
    @Published var amount: Double = 0
    @Published var date: Date = Date.now
    @Published var selectedSubCategoryId: String?
    @Published var selectedCategory: CategoryEntity?
    @Published var categories = [CategoryEntity]()

    @Published var createCategoryViewType: CreateCategoryViewType?
    @Published var categoryColor: Color = .blue
    @Published var categoryTitle: String = ""
    
    private let categoriesStore: CategoriesStore
    private var cancellable = Set<AnyCancellable>()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext, transactionType: TransactionType){
        self.context = context
        self.transactionType = transactionType
        categoriesStore = CategoriesStore(context: context)
        
        startSubsCategories()
        
        categoriesStore.fetch()
        
    }
    
    var disabledSave: Bool{
        amount == 0 || selectedCategory == nil
    }
    
    
    private func startSubsCategories(){
        categoriesStore.categories
            .sink { categories in
                self.categories = categories
            }
            .store(in: &cancellable)
    }
    
    
    func toogleSelectCategory(_ category: CategoryEntity){
        selectedCategory = category.objectID == selectedCategory?.objectID ? nil : category
    }
    
    func toogleSelectSubcategory(_ categoryId: String){
        selectedSubCategoryId = categoryId == selectedSubCategoryId ? nil : categoryId
    }
    
    func create(type: TransactionType, date: Date, forAccount: AccountEntity?, created: UserEntity?){
        guard let selectedCategory, let forAccount, let created else { return }
        TransactionEntity.create(amount: amount, createAt: date, type: type, created: created, account: forAccount, category: selectedCategory, subcategoryId: selectedSubCategoryId, note: note, context: context)
    }

    func addCategory(forAccount: AccountEntity){
        let category = CategoryEntity.create(context: context, forAccount: forAccount, title: categoryTitle, color: categoryColor.toHex(), subcategories: nil, isParent: true, type: transactionType)
        context.saveContext()
        createCategoryViewType = nil
        categoryTitle = ""
        selectedCategory = category
    }
    
    func addSubcategory(forAccount: AccountEntity){
        if let selectedCategory{
            let subcategory = CategoryEntity.create(context: context, forAccount: forAccount, title: categoryTitle, color: categoryColor.toHex(), subcategories: nil, isParent: false, type: transactionType)
            selectedCategory.wrappedSubcategories = [subcategory]
            context.saveContext()
            createCategoryViewType = nil
            categoryTitle = ""
            selectedSubCategoryId = subcategory.id
        }
    }
}
