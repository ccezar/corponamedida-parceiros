//
//  ViewController.swift
//  Parceiros
//
//  Created by Caio Cezar Lopes dos Santos on 04/06/15.
//  Copyright (c) 2015 Corpo na Medida. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var parceiroView: UIView!
    @IBOutlet weak var fotoParceiro: UIImageView!
    @IBOutlet weak var nomeParceiroLabel: UILabel!
    @IBOutlet weak var tipoParceiroLabel: UILabel!
    @IBOutlet weak var bottonConstraintViewParceiro: NSLayoutConstraint!
    
    let pontoInicial = CLLocation(latitude: -12.29536, longitude: -53.06786)
    
    var parceiros = [Parceiro]()
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        searchBar.delegate = self
        
        carregarParceiros()
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        
        let ponto = sender.locationInView(mapView)
        let view : UIView = mapView.hitTest(ponto, withEvent: nil)!
        
        if toString(view.dynamicType) == "MKModernUserLocationView" {
            // clicou na localização do usuário
            return
        }
        
        if toString(view.dynamicType) == "MKNewAnnotationContainerView" {
            NSLog("clicou no mapa")
        } else {
            if view is MKAnnotationView {
                let pin = view as! MKAnnotationView
                let parceiro = pin.annotation as! Parceiro
                
                let url = NSURL(string: parceiro.imagem)
                let data = NSData(contentsOfURL: url!)
                
                fotoParceiro.image = UIImage(data: data!)
                nomeParceiroLabel.text = parceiro.nome
                tipoParceiroLabel.text = parceiro.tipo
                
                mostrarViewParceiro()
            }
        }
    }
    
    @IBAction func abrirBusca(sender: AnyObject) {
        if !searchBar.hidden {
            self.view.endEditing(true)
        }
        
        searchBar.hidden = !searchBar.hidden
    }
    
    @IBAction func abrirPaginaParceiro(sender: UIButton) {
        NSLog("Chamar webview")
    }
    
    @IBAction func fecharViewParceiro(sender: UIButton) {
        ocultarViewParceiro()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.hidden = true
        self.view.endEditing(true)
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
    
    func mostrarViewParceiro() {
        let view = self.parceiroView
        bottonConstraintViewParceiro.constant = 0
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            view.layoutIfNeeded()
        })
    }
    
    func ocultarViewParceiro() {
        let view = self.parceiroView
        bottonConstraintViewParceiro.constant = view.frame.height * -1
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            view.layoutIfNeeded()
        })
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
        
        if (locationManager.location != nil) {
            centralizarMapa(locationManager.location, raio: 9000)
        }
    }

}

