//
//  Helper.swift
//  MVVMForCountry
//
//  Created by Knoxpo MacBook Pro on 10/05/21.
//


import Combine
import SwiftUI
extension ProcessInfo {
    var isRunningTests: Bool {
        environment ["XCTestConfigurationFilePath"] != nil
        
    }
}

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        
        }
    }
}

internal final class inspection<V> where V: View {
    
    
    
    
    
    
    
}


