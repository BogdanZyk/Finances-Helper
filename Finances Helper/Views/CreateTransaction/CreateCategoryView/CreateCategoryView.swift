//
//  CreateCategoryView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 03.04.2023.
//

import SwiftUI

struct CreateCategoryView: View {
    let viewType: CreateCategoryViewType
    @ObservedObject var createVM: CreateTransactionViewModel
    var body: some View {
        VStack{
            
        }
    }
}

struct CreateCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCategoryView(viewType: .new(isSub: true), createVM: CreateTransactionViewModel(context: dev.viewContext))
    }
}


extension CreateCategoryView{
    
    enum CreateCategoryViewType: Identifiable{
        
        case new(isSub: Bool)
        case edit(isSub: Bool, CategoryEntity)
        
        var id: Int{
            switch self{
            case .new: return 0
            case .edit: return 1
            }
        }
        
        var navTitle: String{
            switch self{
            case .new(let isSub):
                return "New \(isSub ? "Subcategory" : "Category")"
            case .edit(let isSub, _):
                return "Edit \(isSub ? "Subcategory" : "Category")"
            }
        }
    }
}
