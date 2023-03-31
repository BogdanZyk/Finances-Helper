//
//  RootViewModel.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData
import Combine

final class RootViewModel: ObservableObject{
    
    @Published var transactions = [TransactionEntity]()
    @Published var selectedDate: Date = .now
    let coreDataManager: CoreDataManager
    let trasactionStore: TransactionStore
    private var cancellable = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext){
        coreDataManager = CoreDataManager(mainContext: context)
        trasactionStore = TransactionStore(context: context)
        
        coreDataManager.createAccountIfNeeded()
        
        fetchTransactionForDate()
        
        startSubsTransaction()
    }
    
    
    private func startSubsTransaction(){
        trasactionStore.groups
            .sink { transactions in
                self.transactions = transactions
            }
            .store(in: &cancellable)
    }
    
  
    
    func fetchTransactionForDate(){
       guard let datePredicate = NSPredicate.datePredicate(before: selectedDate.noon, after: selectedDate.dayAfter) else { return }
        trasactionStore.fetch(for: datePredicate)
    }
}
