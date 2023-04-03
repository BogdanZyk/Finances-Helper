//
//  UserService.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 03.04.2023.
//

import Foundation
import SwiftUI
import CoreData

final class UserService: ObservableObject{
    
    @AppStorage("currentUserId") private var currentUserId: String = ""
    @Published var currentUser: UserEntity?
    let coreDataManager: CoreDataManager
    
    
    init(context: NSManagedObjectContext){
        self.coreDataManager = CoreDataManager(mainContext: context)
        fetchUser()
    }
    
    
    func fetchUser(){
        currentUser = coreDataManager.getCurrentUser(id: currentUserId)
        currentUserId = currentUser?.id ?? ""
    }
}
