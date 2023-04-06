//
//  CancelBag.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 06.04.2023.
//

import Foundation
import Combine

final class CancelBag {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
