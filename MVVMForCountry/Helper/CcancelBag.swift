//
//  CcancelBag.swift
//  MVVMForCountry
//
//  Created by Knoxpo MacBook Pro on 10/05/21.
//

import Foundation
import Combine

final class CancelBag {
    fileprivate(set) var subsriptions = Set<AnyCancellable>()
    func cancel() {
        subsriptions.removeAll()
    }
    
    
    
}
extension AnyCancellable {
    
    func store(in cancelBag: CancelBag) {
        cancelBag.subsriptions.insert(self)
    }
    
}
