//
//  CategoriesTagsView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 03.04.2023.
//

import SwiftUI

struct CategoriesTagsView: View {
    @ObservedObject var createVM: CreateTransactionViewModel
   
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category")
                .font(.title3.bold())
            if let selectedCategory = createVM.selectedCategory{
                tagView(selectedCategory, isSubcategory: false)
                Text("Subcategory")
                    .font(.title3.bold())
                tagsList(Array(selectedCategory.wrappedSubcategories), isSubcategory: true)
            }else{
                tagsList(createVM.categories, isSubcategory: false)
            }
        }
        .hLeading()
    }
}

struct CategoryTagView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesTagsView(createVM: CreateTransactionViewModel(context: dev.viewContext))
            .padding()
    }
}


extension CategoriesTagsView{
    
    private func tagView(_ category: CategoryEntity, isSubcategory: Bool) -> some View{
        Text(category.title ?? "")
            .foregroundColor(.white)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(category.wrappedColor, in: Capsule())
            .onTapGesture {
                if isSubcategory{
                    createVM.toogleSelectSubcategory(category.id ?? "")
                }else{
                    createVM.toogleSelectCategory(category)
                }
            }
    }
    
    
    private func tagsList(_ categories: [CategoryEntity], isSubcategory: Bool) -> some View{
        TagLayout(alignment: .leading) {
            ForEach(categories) { category in
                tagView(category, isSubcategory: isSubcategory)
            }
        }
    }
}
