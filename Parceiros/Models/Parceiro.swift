//
//  Parceiro.swift
//  Parceiros
//
//  Created by Caio Cezar Lopes dos Santos on 04/06/15.
//  Copyright (c) 2015 Corpo na Medida. All rights reserved.
//

import MapKit
import AddressBook

class Parceiro: NSObject, MKAnnotation {
    let id: String
    let nome: String
    let tipo: String
    let tipoUrl: String
    let imagem: String
    let url: String
    let coordinate: CLLocationCoordinate2D
    
    init(id: String, nome: String, tipo: String, tipoUrl: String, imagem: String, url: String, latitude: String, longitude: String) {
        self.id = id
        self.nome = nome
        self.tipo = tipo
        self.tipoUrl = tipoUrl
        self.imagem = imagem
        self.url = url
        
        let latitudeFormatada = latitude.stringByReplacingOccurrencesOfString(",", withString: ".") as NSString
        let longitudeFormatada = longitude.stringByReplacingOccurrencesOfString(",", withString: ".") as NSString
        
        self.coordinate = CLLocationCoordinate2D(latitude: latitudeFormatada.doubleValue,
                                                 longitude: longitudeFormatada.doubleValue)
        
        super.init()
    }
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
    var title: String {
        return nome
    }
    
    var subtitle: String {
        return ""
    }
}
