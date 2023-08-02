//
//  HomeView.swift
//  LoginFirebase
//
//  Created by Luciano Nicolini on 28/07/2023.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color("Color").ignoresSafeArea(.all)
                    .ignoresSafeArea()
                ScrollView(.vertical,showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
            
                        MiddleView()
                        NovedadesView()
                       

                    }
                }
                .navigationBarTitle("Nuestros Destinos", displayMode: .large)
                
            }
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct MiddleView: View {
    var features: [Feature] = Feature.sampleData
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(features) { feature in
                    VStack(alignment: .leading, spacing: 5) {
                        NavigationLink(destination: Text("newvista")) {
                            Image(feature.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 240, height: 300)
                                .cornerRadius(10)
                        }
                        Text(feature.name).fontWeight(.medium)
                        HStack {
                            Label(feature.subtitle, systemImage: "mappin")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
    }
}





struct NovedadesView: View {
    var novedades: [Novedad] = Novedad.sampleData 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Novedades")
                .font(.title)
                .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(novedades) { item in
                    NovedadCard(item: item)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct NovedadCard: View {
    var item: Novedad

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink(destination: Text("Nueva Vista")) {
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            Text(item.title)
                .font(.headline)
            Text(item.date)
                .font(.footnote)
                .foregroundColor(.gray)
            Text(item.description)
                .font(.body)
                .lineLimit(3)
        }
        .padding(.vertical)
    }
}




