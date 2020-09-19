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
    
    var baseURLString:String? = nil
    
    var baseURL: URL {
        
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func createAndConfirmPayment(_ token: STPToken, amount: Int, completion: @escaping (_ error: Error?) -> Void) {
        
        let url = self.baseURL.appendingPathComponent("charge")
        
        let params: [String : Any] = ["stripeToken" : token.tokenId, "amount" : amount, "description" : Constants.defaultDescription, "currency" : Constants.defaultCurrency]
        let serializer = DataResponseSerializer(emptyResponseCodes: Set([200,204,205]))
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .response(responseSerializer: serializer) { (response) in
                print(response)

                switch response.result {
                case .success( _):
                    print("Payment successful")
                    completion(nil)
                case .failure(let error):
                    if (response.data?.count)! > 0 {print(error)}

                    if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                        print("Server Error: " + str)
                    }
                    completion(error)
                }

            }

        }
    }
