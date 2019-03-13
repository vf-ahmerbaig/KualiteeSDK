//
//  CanvasViewDelegate.swift
//  KualiteeSDKSwift
//
//  Created by VF on 07/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import UIKit

protocol CanvasViewDelegate: class {
    func sendCapturedScreenShot(image: UIImage)
}
