//
//  NetworkManager.swift
//  KualiteeSDKSwift
//
//  Created by VF on 06/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import UIKit

internal class NetworkManager {
    private init() {}
    
    internal class func fetchDataFromServer(url: String, completionHandler: @escaping (Data?) -> ()) {
        guard let url = URL(string: url) else {
            completionHandler(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    completionHandler(nil)
                    return
                }
                completionHandler(data)
            }
        }
        task.resume()
    }
}
