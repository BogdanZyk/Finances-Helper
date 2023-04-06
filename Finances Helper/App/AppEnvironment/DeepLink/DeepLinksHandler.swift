//
//  DeepLinkHandler.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 06.04.2023.
//


import Foundation

// MARK: - DeepLinksHandler
protocol DeepLinksHandlerProtocol {
    func open(deepLink: DeepLink)
}

struct DeepLinksHandler: DeepLinksHandlerProtocol {
    
    private let rootVM: RootViewModel
    
    init(rootVM: RootViewModel) {
        self.rootVM = rootVM
    }
    
    
    func open(deepLink: DeepLink) {
//        switch deepLink {
//        case .openOrder(let id):
//            mainViewModel.openOrder(id)
//        case .product(let slug):
//            mainViewModel.openProduct(for: slug)
//        case .profile(let type):
//            mainViewModel.openProfileLink(type)
//        case .tab(let tab):
//            mainViewModel.tabAction(tab)
//        }
    }
}

