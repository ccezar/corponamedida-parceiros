//
//  BaseClient.swift
//  Parceiros
//
//  Created by Caio Cezar Lopes dos Santos on 04/06/15.
//  Copyright (c) 2015 Corpo na Medida. All rights reserved.
//

import UIKit

private let URL = "http://corponamedida.com.br"
private let ORIGEM = ""
private let USER = ""
private let PASSWORD = ""
private let CONTAB = ""
private let APIKEY = ""

typealias AFSuccessBlock = (AFHTTPRequestOperation, AnyObject!) -> (Void)
typealias AFFailureBlock = (AFHTTPRequestOperation, NSError!) -> (Void)

class BaseClient: NSObject {
    
    let serviceEndpoint:String
    private let manager = AFHTTPRequestOperationManager()
    private var cached = false
    
    init(endpoint: Endpoint) {
        self.serviceEndpoint = URL + endpoint.rawValue + ORIGEM
        
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer(writingOptions: nil)
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue(CONTAB, forHTTPHeaderField: "User-Agent")
        manager.requestSerializer.setValue(APIKEY, forHTTPHeaderField: "ZAP-ApiKey")
        //manager.requestSerializer.setValue(BaseClient.authHash(), forHTTPHeaderField: "Authorization")
        
        manager.requestSerializer.timeoutInterval = 60
        
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        
        super.init()
    }
    
    func POST(parameters: [String: AnyObject],
        headers: [NSObject: AnyObject]?,
        success: AFSuccessBlock,
        failure: AFFailureBlock) {
            
            if headers != nil  {
                manager.requestSerializer.setValuesForKeysWithDictionary(headers!)
            }
            
            manager.POST(serviceEndpoint,
                parameters: parameters,
                success: { (operation, responseObject) -> Void in
                    success(operation, responseObject);
                },
                failure: { (operation, errorObject) -> Void in
                    failure(operation, errorObject);
                }
            )
    }
    
    func GET(parameters: NSDictionary?,
        headers: [NSObject: String]?,
        success: AFSuccessBlock,
        failure: AFFailureBlock) {
            
            if headers != nil  {
                manager.requestSerializer.setValuesForKeysWithDictionary(headers!)
            }
            
            manager.GET(serviceEndpoint,
                parameters: parameters,
                success: { (operation, responseObject) -> Void in
                    success(operation, responseObject);
                },
                failure: { (operation, errorObject) -> Void in
                    failure(operation, errorObject);
                }
            );
    }
    
    func PUT(parameters: [String: AnyObject],
        headers: [NSObject: AnyObject]?,
        success: AFSuccessBlock,
        failure: AFFailureBlock) {
            
            if headers != nil  {
                manager.requestSerializer.setValuesForKeysWithDictionary(headers!)
            }
            
            manager.PUT(serviceEndpoint,
                parameters: parameters,
                success: { (operation, responseObject) -> Void in
                    success(operation, responseObject);
                },
                failure: { (operation, errorObject) -> Void in
                    failure(operation, errorObject);
                }
            );
            
    }
    
    func DELETE(parameters: NSDictionary,
        headers: [NSObject: AnyObject]?,
        success: AFSuccessBlock,
        failure: AFFailureBlock) {
            
            if headers != nil  {
                manager.requestSerializer.setValuesForKeysWithDictionary(headers!)
            }
            
            manager.DELETE(serviceEndpoint,
                parameters: nil,
                success: { (operation, responseObject) -> Void in
                    success(operation, responseObject);
                },
                failure: { (operation, errorObject) -> Void in
                    failure(operation, errorObject);
                }
            );
    }
    
    class private func authHash() -> String
    {
        let authString = USER + ":" + PASSWORD;
        let dataAuth = authString.dataUsingEncoding(NSUTF8StringEncoding);
        let dataAuthString = dataAuth?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        let hash = String(format: "Basic %@", dataAuthString!)
        
        return hash;
    }
    
}
