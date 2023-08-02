//
//  ContentView.swift
//  LoginFirebase
//
//  Created by Luciano Nicolini on 27/07/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Primero")
                }
            
            Text("")
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Segundo")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


