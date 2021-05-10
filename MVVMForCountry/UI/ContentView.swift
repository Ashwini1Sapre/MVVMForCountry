//
//  ContentView.swift
//  MVVMForCountry
//
//  Created by Knoxpo MacBook Pro on 10/05/21.
//

import SwiftUI
import  CoreData
struct ContentView: View {
    var body: some View {
        NavigationView {
        VStack {
            
            HStack {
            Text("Light/Dark")
            }
            
            HStack {
            Text ("Locale")
            }
            
            HStack {
            Text("Text")
            }
            
            HStack {
            Text("Inverse Layout")
            }
            
            HStack {
            Text ("Accesibility")
            }
            
            
            Button("Take A ScreenShot") {
                
                
                
            }
        }
            
       
            
        }
      //  .navigationBar
        
       
            //.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
