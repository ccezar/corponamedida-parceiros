//
//  ViewController.swift
//  Parceiros
//
//  Created by Caio Cezar Lopes dos Santos on 04/06/15.
//  Copyright (c) 2015 Corpo na Medida. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let pontoInicial = CLLocation(latitude: -12.29536, longitude: -53.06786)
    
    var parceiros = [Parceiro]()
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        carregarParceiros()
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        
        let ponto = sender.locationInView(mapView)
        let view : UIView = mapView.hitTest(ponto, withEvent: nil)!
        
        let annotation : AnyObject
        if view.isKindOfClass(MKAnnotationView) {
            NSLog("clicou na annotation")
        } else if toString(view.dynamicType) == "MKNewAnnotationContainerView" {
            searchBar.hidden = !searchBar.hidden
        }
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            setarLocalizacaoUsuario()
        } else {
            centralizarMapa(pontoInicial, raio: 4000000)
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == .Denied ) {
            // The user denied authorization
        } else if (status == .AuthorizedWhenInUse) {
            setarLocalizacaoUsuario()
        }
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
    
    func centralizarMapa(ponto: CLLocation, raio: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(ponto.coordinate,
                                                                  raio * 2.0,
                                                                  raio * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setarLocalizacaoUsuario() {
        let locationManager = CLLocationManager()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation();
        
        centralizarMapa(locationManager.location, raio: 9000)
    }

}

