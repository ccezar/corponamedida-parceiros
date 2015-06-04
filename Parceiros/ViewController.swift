//
//  ViewController.swift
//  Parceiros
//
//  Created by Caio Cezar Lopes dos Santos on 04/06/15.
//  Copyright (c) 2015 Corpo na Medida. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    
    let pontoInicial = CLLocation(latitude: -12.29536, longitude: -53.06786)
    let raio: CLLocationDistance = 4000000
    var parceiros = [Parceiro]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        centralizarMapa(pontoInicial)
        carregarParceiros()
    }
    
    func carregarParceiros()
    {
        let success:AFSuccessBlock = { (operation, response) -> (Void) in
            if let parceiros = response as? [Parceiro] {
                self.parceiros = parceiros
                self.mapView.addAnnotations(self.parceiros)
            }
        }
        
        let fail:AFFailureBlock = { (response, error) -> (Void) in
            AppHelper.showAlert("Não foi possível carregar os parceiros, tente novamente")
        }
        
        ParceiroClient().listar(success, failure: fail)
    }
    
    override func viewWillAppear(animated: Bool){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    func centralizarMapa(ponto: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(ponto.coordinate,
                                                                  raio * 2.0,
                                                                  raio * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    

}

