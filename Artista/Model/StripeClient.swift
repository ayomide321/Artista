//
//  StripeClient.swift
//  Artista
//
//  Created by Ayomide Omolewa on 7/2/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import Foundation
import Stripe
import Alamofire


class StripeClient {
    
    static let sharedClient = StripeClient()
    
    var baseURLString: String? = nil
    
    var baseURL: URL {
        
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func createAndConfirmPayment(_ token: STPToken, amount: Int, completion: @escaping(_ error: Error?) -> Void) {
        
        
    }
    
    
}
