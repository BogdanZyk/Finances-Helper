//
//  CategoriesViewModel.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 06.04.2023.
//

import Foundation
import CoreData

class CategoriesViewModel: ObservableObject{
    
    
    @Published private(set) var categories = [CategoryEntity]()
    
    private var cancelBag = CancelBag()
    private let context: NSManagedObjectContext
    private let categoriesStore: ResourceStore<CategoryEntity>
    
    init(context: NSManagedObjectContext){
        self.context = context
        self.categoriesStore = ResourceStore(context: context)
        
        subsCategories()
        fetchCategories()
    }
    
    
    private func fetchCategories(){
        let request = CategoryEntity.request()
        categoriesStore.fetch(request)
    }
    
    private func subsCategories(){
        categoriesStore.resources
            .sink {[weak self] categories in
                guard let self = self else {return}
                self.categories = categories
            }
            .store(in: cancelBag)
    }
}
