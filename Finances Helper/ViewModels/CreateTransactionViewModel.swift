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
    
    
    @Published var note: String = ""
    @Published var amount: Double = 0
    @Published var date: Date = Date.now
    @Published var selectedSubCategoryId: String?
    @Published var selectedCategory: CategoryEntity?
    @Published var categories = [CategoryEntity]()
    @Published var categoryColor: Color = .blue
    
    private let categoriesStore: CategoriesStore
    private var cancellable = Set<AnyCancellable>()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
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
}
