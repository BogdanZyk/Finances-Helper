//
//  CreateTransactionViewModel.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation

class CreateTransactionViewModel: ObservableObject{
    
    
    @Published var note: String = ""
    @Published var amount: Double = 0
}
