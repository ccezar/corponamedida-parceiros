//
//  ParceiroClient.swift
//  Parceiros
//
//  Created by Caio Cezar Lopes dos Santos on 04/06/15.
//  Copyright (c) 2015 Corpo na Medida. All rights reserved.
//

import UIKit

class ParceiroClient: BaseClient {
    
    init () {
        super.init(endpoint: .ListarParceiros)
    }
    
    func listar(success: AFSuccessBlock, failure: AFFailureBlock)
    {
        let success:AFSuccessBlock = { (operation, response) -> Void in
            
            var parceiros = [Parceiro]()
            
            if let lista = response as? NSArray {
                for item in lista {
                    let dictionary = item as! NSDictionary
                    let parceiro = Parceiro(id: item["Id"] as! String,
                                            nome: item["Nome"] as! String,
                                            tipo: item["Tipo"] as! String,
                                            tipoUrl: item["TipoUrl"] as! String,
                                            imagem: item["Imagem"] as! String,
                                            url: item["URL"] as! String,
                                            latitude: item["Latitude"] as! String,
                                            longitude: item["Longitude"] as! String)
                    
                    parceiros.append(parceiro)
                }            }
            
            success(operation, parceiros)
        }
        
        let failure:AFFailureBlock = { (operation, error) -> Void in
            failure(operation, error)
        }
        
        GET(nil, headers: nil, success: success, failure: failure)
    }
    
}