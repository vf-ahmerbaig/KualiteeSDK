//
//  UIWindow+Extension.swift
//  KualiteeSDKSwift
//
//  Created by VF on 05/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import UIKit

internal extension UIWindow {
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if KualiteeSDK.hasConfigured {
            KualiteeSDK.observe(motion: motion)
        }
    }
}
