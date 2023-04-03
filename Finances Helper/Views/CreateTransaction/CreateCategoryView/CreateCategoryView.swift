//
//  CreateCategoryView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 03.04.2023.
//

import SwiftUI

struct CreateCategoryView: View {
    let viewType: CreateCategoryViewType
    @ObservedObject var rootVM: RootViewModel
    @ObservedObject var createVM: CreateTransactionViewModel
    @State var colors = (1...10).map({_ in Color.random})
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(spacing: 32){
            headerView
            VStack {
                TextField("Title", text: $createVM.categoryTitle)
                    .focused($isFocused)
                Divider()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack{
                    ForEach(colors, id: \.self){color in
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .scaleEffect(color == createVM.categoryColor ? 1.2 : 1)
                            .opacity(color == createVM.categoryColor ? 1 : 0.5)
                            .onTapGesture {
                                createVM.categoryColor = color
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 50)
            .padding(.horizontal, -16)
            .onAppear{
                if let color = colors.first{
                    createVM.categoryColor = color
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02){
                    isFocused = true
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
}

struct CreateCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.secondary
            CreateCategoryView(viewType: .new(isSub: true), rootVM: RootViewModel(context: dev.viewContext), createVM: CreateTransactionViewModel(context: dev.viewContext))
                .padding()
        }
    }
}


extension CreateCategoryView{
    
    private var headerView: some View{
        HStack{
            Button {
                isFocused = false
                createVM.createCategoryViewType = nil
            } label: {
                Image(systemName: "xmark")
            }
            Spacer()
            Text(viewType.navTitle)
                .font(.headline.bold())
            Spacer()
            
            Button {
                isFocused = false
                if let account = rootVM.account{
                    switch viewType{
                    case .new(let isSubcategory):
                        if isSubcategory{
                            createVM.addSubcategory(forAccount: account)
                        }else{
                            createVM.addCategory(forAccount: account)
                        }
                    case .edit:
                        break
                    }
                }
            } label: {
                Image(systemName: "checkmark")
            }
            .disabled(createVM.categoryTitle.isEmpty)
        }
    }
    

}

enum CreateCategoryViewType: Identifiable, Equatable{
    
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
            return "New \(isSub ? "subcategory" : "category")"
        case .edit(let isSub, _):
            return "Edit \(isSub ? "subcategory" : "category")"
        }
    }
}
