//
//  ViewController+MapView.swift
//  Parceiros
//
//  Created by Caio Cezar Lopes dos Santos on 04/06/15.
//  Copyright (c) 2015 Corpo na Medida. All rights reserved.
//

import MapKit

extension ViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Parceiro {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                // Não vou mostrar o balão em cima do pin
                //view.canShowCallout = true
                //view.calloutOffset = CGPoint(x: -5, y: 5)
                //view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            
            view.image = UIImage(named: annotation.tipoUrl)
            
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
//        let parceiro = view.annotation as! Parceiro
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
    
        // Abre o mapa nativo do device mostrando a rota até o ponto
        //parceiro().openInMapsWithLaunchOptions(launchOptions)
        
        /*
        var imgURL: NSURL = NSURL(string: parceiro.imagem)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    self.fotoParceiro.image = UIImage(data: data)
                    self.nomeParceiroLabel.text = parceiro.nome
                    self.tipoParceiroLabel.text = parceiro.tipo
                    self.mostrarViewParceiro(self.parceiroView)
                }
        })

        let url = NSURL(string: parceiro.imagem)
        let data = NSData(contentsOfURL: url!)
        
        fotoParceiro.image = UIImage(data: data!)
        nomeParceiroLabel.text = parceiro.nome
        tipoParceiroLabel.text = parceiro.tipo
        
        mostrarViewParceiro()
        */
        
    }
    
}
