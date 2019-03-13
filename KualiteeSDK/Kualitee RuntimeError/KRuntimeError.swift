//
//  KRuntimeError.swift
//  KualiteeSDKSwift
//
//  Created by VF on 06/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import Foundation

public struct KRuntimeError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var localizedDescription: String {
        return message
    }
}
