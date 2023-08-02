//
//  FeatureModel.swift
//  LoginFirebase
//
//  Created by Luciano Nicolini on 28/07/2023.
//

import Foundation

struct Feature: Identifiable {
    var id = UUID()
    let imageName: String
    let name: String
    let subtitle: String
    
    init(id: UUID = UUID(), imageName: String, name: String, subtitle: String) {
        self.id = id
        self.imageName = imageName
        self.name = name
        self.subtitle = subtitle
    }
}

extension Feature {
    static let sampleData: [Feature] =
    [
        Feature(imageName: "Uno_feature", name: "Bariloche", subtitle: "Argentina"),
        Feature(imageName: "Dos_feature", name: "Mar del Plata", subtitle: "Argentina"),
        Feature(imageName: "Tres_feature", name: "Sierras de Cordoba", subtitle: "Argentina"),
        Feature(imageName: "Cuatro_feature", name: "Buenos Aires", subtitle: "Argentina")
    ]
}


struct Novedad: Identifiable {
    var id: UUID
    var imageName: String
    var title: String
    var date: String
    var description: String
    
    static var sampleData: [Novedad] = [
        Novedad(id: UUID(), imageName: "hoteleria", title: "Hoteleria Convenida Iosfa", date: "26 Julio, 2023", description: "IOSFA ofrece opciones turísticas en Misiones, Entre Ríos, Mendoza y Costa Atlántica gracias a acuerdos exclusivos para afiliados."),
        Novedad(id: UUID(), imageName: "promocion", title: "Promoción Exclusiva", date: "20 Julio, 2023", description: "25% de descuento en empresas de transporte."),
        // ... añade más datos de muestra según lo necesites
    ]
}


