//
//  URL+Extension.swift
//  KualiteeSDKSwift
//
//  Created by VF on 06/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import UIKit

extension URL {
    
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    
    internal static func queryString(_ value: String, params: [String: String]) -> URL? {
        var components = URLComponents(string: value)
        components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value) }
        return components?.url
    }
}
