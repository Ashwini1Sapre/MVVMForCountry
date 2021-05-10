//
//  ExampleApplyModel.swift
//  MVVMForCountry
//
//  Created by Knoxpo MacBook Pro on 10/05/21.
//

import Foundation

extension Country {
    static let mockData: [Country] = [
    

    Country(name: "UnitedState", translations: [:], population: 1250000, flag: URL(string: ""), aplpha3Code: "USA"),
        
        Country(name: "India", translations: [:], population: 123456344, flag: URL(string: ""), aplpha3Code: "IN"),
        
        
        Country(name: "UnitedKingdom", translations: [:], population: 232423434, flag: URL(string: ""), aplpha3Code: "UK")
        
    ]
}
    
   

extension Country.Currency {
        
        
        static let mockData: [Country.Currency] = [
          
            Country.Currency(code: "IN", symbol: "₹", name: "Rupee"),
            Country.Currency(code: "USD", symbol: "$", name: "US doller"),
            Country.Currency(code: "EUR", symbol: "€", name: "Euro")
        
        
        ]
        
        
        
    }
    
    

extension Country.Details {
    
    static let mockData: [Country.Details] = [
    
        Country.Details(capital: "Delhi", currencies: Country.Currency.mockData, neighbors: Country.mockData),
        Country.Details(capital: "Sin City", currencies: Country.Currency.mockData, neighbors: []),
        Country.Details(capital: "London", currencies: Country.Currency.mockData, neighbors: Country.mockData)
        
        
    
    
    ]
    
    
    
    
}
    
    
    
    
