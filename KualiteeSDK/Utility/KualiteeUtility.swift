//
//  KualiteeUtility.swift
//  KualiteeSDKSwift
//
//  Created by VF on 07/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import UIKit

enum KualiteeUtility {
    static func getSDKBundle() -> Bundle? {
        //        let bundlePath = Bundle.main.path(forResource: "KualiteeSDKSwift", ofType: "bundle")
        //        return Bundle(path: bundlePath ?? "")
        return Bundle(identifier: KualiteeSDKConstants.AppID)
    }
    
    internal static func standardAlert(controller: UIViewController, title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { action in
            
        }
        alertController.addAction(OkAction)
        controller.present(alertController, animated: true) {
        }
    }
}
