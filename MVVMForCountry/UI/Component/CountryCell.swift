//
//  CountryCell.swift
//  MVVMForCountry
//
//  Created by Knoxpo MacBook Pro on 10/05/21.
//

import SwiftUI

struct CountryCell: View {
    var country: Country
    @Environment(\.locale) var locale: Locale
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(country.name(locale: locale))
                .font(.largeTitle)
            Text("Population: \(country.population)")
                .font(.title)
            
            
            
        }
        
        .padding()
        .frame(width: .infinity, height: 50, alignment: .leading)
    }
}

struct CountryCell_Previews: PreviewProvider {
    static var previews: some View {
        CountryCell(country: Country.mockData[0])
            .previewLayout(.fixed(width: 200, height: 100))
    }
}
