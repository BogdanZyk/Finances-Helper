//
//  CategoryTagsView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 03.04.2023.
//

//import SwiftUI
//import Algorithms
//
//struct CategoryTagsView: View {
//    @ObservedObject var rootVM: RootViewModel
//    var allTransactionCategories: [CategoryEntity]{
//        rootVM.transactions.compactMap({$0.category}).uniqued(on: {$0.id})
//    }
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            if let selectCategory = rootVM.selectedCategory{
//                categorySingleTagView(selectCategory, isSelected: true)
//
//                if selectCategory.isParent{
//                    TagLayout(alignment: .leading, spacing: 10){
//                        ForEach(Array(selectCategory.wrappedSubcategories)) { category in
//                            categorySingleTagView(category, isSelected: false, isSubcategory: true)
//                        }
//                    }
//                }
//            }else{
//                TagLayout(alignment: .leading, spacing: 10){
//                    ForEach(Array(allTransactionCategories)) { category in
//                        categorySingleTagView(category, isSelected: false)
//                    }
//                }
//            }
//        }
//        .hLeading()
//    }
//}
//
//struct CategoryTagsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryTagsView(rootVM: RootViewModel(context: dev.viewContext))
//            .padding()
//    }
//}
//
//extension CategoryTagsView{
//
//    private func categorySingleTagView(_ category: CategoryEntity, isSelected: Bool, isSubcategory: Bool = false) -> some View{
//        HStack {
//            Text(category.title ?? "")
//            if isSelected{
//                Button {
//                    rootVM.selectedCategory = nil
//                } label: {
//                    Image(systemName: "xmark.circle.fill")
//                }
//            }
//        }
//        .foregroundColor(.white)
//        .padding(.vertical, 5)
//        .padding(.horizontal, 10)
//        .background(category.wrappedColor, in: Capsule())
//        .onTapGesture {
//            if !isSelected{
//                rootVM.selectCategory(category)
//            }
//        }
//    }
//
//}
