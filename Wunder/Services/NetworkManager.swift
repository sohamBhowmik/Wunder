//
//  NetworkManager.swift
//  Wunder
//
//  Created by Soham Bhowmik on 09/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let sharedManager = NetworkManager()
    
    let carListUrlString = "https://s3-us-west-2.amazonaws.com/wunderbucket/locations.json"
    
    func donwloadCarData(completion:@escaping (_ carsList: [Car]?, _ error: [AnyHashable:Any]?) -> ())
    {
        if let url = URL(string: carListUrlString)
        {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else{
                    return
                }
                
                if error != nil {
                    
                    DispatchQueue.main.async {
                        completion(nil, error!._userInfo as? [AnyHashable : Any])
                    }
                }
                else{
                    do {
                        let placemark = try JSONDecoder().decode(Placemark.self, from: data) as Placemark
                        DispatchQueue.main.async {
                            completion(placemark.placemarks,nil)
                        }
                    }
                    catch{
                        DispatchQueue.main.async {
                            let userInfo: [AnyHashable : Any] =
                                [
                                    NSLocalizedDescriptionKey :  NSLocalizedString("Invalid json structure", value: "Invalid json structure", comment: "") ,
                                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Invalid json structure", value: "Invalid json structure", comment: "")
                            ]
                            completion(nil, userInfo)
                        }
                    }
                }
                
            }.resume()
        }
        else
        {
            let userInfo: [AnyHashable : Any] =
                [
                    NSLocalizedDescriptionKey :  NSLocalizedString("Invalid URL", value: "Invalid URL", comment: "") ,
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Invalid URL", value: "Invalid URL", comment: "")
            ]
            completion(nil, userInfo)
        }
    }
}
