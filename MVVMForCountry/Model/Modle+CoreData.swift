//
//  Modle+CoreData.swift
//  MVVMForCountry
//
//  Created by Knoxpo MacBook Pro on 10/05/21.
//

import Foundation
import CoreData

extension CountryMO: ManageEntity { }
extension NameTranslationMO: ManageEntity { }
extension CountryDetailsMO: ManageEntity { }
extension CurrencyMO: ManageEntity { }


extension Locale {
    static var backendDefault: Locale {
        return Locale(identifier: "en")
    }
    
    var shortIdentifier: String {
        
        return String(identifier.prefix(2))
    }
    
    
    
}

extension Country.Details {
    init?(managedObject: CountryDetailsMO) {
        
        guard let capital = managedObject.capital else { return nil }
        
        let currencies = (managedObject.currencies ?? NSSet())
            .toArray(of: CurrencyMO.self)
          //  .compactMap { Country.Currency(managedObject: $0) }
            .compactMap { Country.Currency(managedObject: $0) }

        
        
        let borders = (managedObject.borders ?? NSSet() )
            .toArray(of: CountryMO.self)
            .compactMap { Country(managedObject: $0) }
            .sorted(by: {
                $0.name < $1.name
            })
        self.init(capital: capital, currencies: currencies , neighbors: borders)
    }
    
    
    
    
}

extension Country.Currency {
    
    init?(managedObject: CurrencyMO) {
        
        guard let code = managedObject.code,
        let name = managedObject.name
        else {
            return nil
        }
        
        self.init(code: code, symbol: managedObject.symbol, name: name)
        
        
    }
    @discardableResult
    func store(in context: NSManagedObjectContext) -> CurrencyMO? {
        guard let currency = CurrencyMO.insertNew(in: context) else {
            return nil
        }
        currency.code = code
        currency.name = name
        currency.symbol = symbol
        return currency
        
        
        
        
    }
    
    
    
}
extension Country {
    
    @discardableResult
    func store (in context: NSManagedObjectContext) -> CountryMO? {
        
        guard let country = CountryMO.insertNew(in: context)
        else {
            return nil
        }
        
        country.name = name
        country.alpha3code = aplpha3Code
        country.flagURL = flag?.absoluteString
        country.population = Int32(population)
        let translations = self.translations
            .compactMap { (locale,name) -> NameTranslationMO? in
                
                guard let name = name,
                      let translation = NameTranslationMO.insertNew(in: context)
                else { return nil }
                translation.name = name
                translation.locale = locale
                
                return translation
                
                
            }
        country.nameTranslations = NSSet(array: translations)
        return country
    }
    init?(managedObject: CountryMO){
        
        guard let nametranslations = managedObject.nameTranslations
        else { return nil }
        
        let translations: [String: String?] = nametranslations
        
            .toArray(of: NameTranslationMO.self)
            .reduce([:], {(dict, record) -> [String: String?] in
                guard let locale = record.locale,
                      let name = record.name
                else {
                    return dict
                }
                var dict = dict
                dict[locale] = name
                return dict
                
                
                
            } )
        
        guard let name = managedObject.name,
              let alpha3code = managedObject.alpha3code else { return nil }
        
        
        self.init(name: name, translations: translations, population: Int(managedObject.population), flag: managedObject.flagURL.flatMap{URL(string: $0)}, aplpha3Code: alpha3code )
        
        
        //  let name: String
//        let translations:[String : String?]
//        let population: Int
//        let flag: URL?
//        let aplpha3Code: Code
//
//        typealias Code = String
        
    
        
    }
    
    
    
    
}
