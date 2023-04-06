//
//  ProfileViewModel.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 05.04.2023.
//

import Foundation
import CoreData
import Combine

final class ProfileViewModel: ObservableObject{
    
    @Published var user: UserEntity?
    
    private var cancelBag = CancelBag()
    let userService: UserService
    
    init(context: NSManagedObjectContext){
        self.userService = UserService(context: context)
    }
    

    
}
