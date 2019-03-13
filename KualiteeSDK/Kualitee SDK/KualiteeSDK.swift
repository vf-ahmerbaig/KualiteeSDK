//
//  KualiteeSDK.swift
//  KualiteeSDKSwift
//
//  Created by VF on 05/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSS3

public class KualiteeSDK {
    private init() {}
    
    internal static var activityIndicator: KualiteeIndicatorView!
    
    internal static var hasConfigured: Bool = false
    
    public class func configure() {
        hasConfigured = true
        AWSKualiteeS3.configure()
    }
    
    public class func resign() {
        hasConfigured = false
    }
    
    internal class func showLoader(text: String) {
        self.activityIndicator = KualiteeIndicatorView(text: text)
        UIApplication.shared.keyWindow?.addSubview(self.activityIndicator)
    }
    
    internal class func hideLoader() {
        self.activityIndicator.removeFromSuperview()
    }
    
    internal class func observe(motion: UIEvent.EventSubtype) {
        if motion == .motionShake {
            let aView = UIView(frame: UIScreen.main.bounds)
            aView.backgroundColor = UIColor.white
            UIApplication.shared.keyWindow?.addSubview(aView)
            
            UIView.animate(withDuration: 1.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                aView.alpha = 0.0
            }, completion: { (done) -> Void in
                self.presentEditorView()
                aView.removeFromSuperview()
            })
        }
    }
    
    final private class func presentEditorView() {
        let bundle = Bundle(for: CanvasViewController.self)
        let editorVC = CanvasViewController.init(nibName: "CanvasViewController", bundle: bundle)
        guard let vc = UIApplication.shared.keyWindow?.rootViewController,
            let image = self.takeScreenshot() else {
                return
        }
        editorVC.image = image
        editorVC.modalTransitionStyle = .coverVertical
        vc.present(editorVC, animated: true, completion: nil)
    }
    
    final private class func copyImageToSharedBoard(image: UIImage) {
        let pasteBoard = UIPasteboard(name: UIPasteboard.Name.init(rawValue: KualiteeSDKConstants.KualiteeSharedImageID), create: true)
        pasteBoard?.image = image
    }
    
    final internal class func showDeepLinkedApp(key: String, completionHandler: @escaping (Bool) -> ()) {
        let appPath = "\(KualiteeSDKConstants.deepLinkId)://?\(KualiteeSDKConstants.KualiteeSharedImageURL)=\(KualiteeSDKConstants.KualiteeSharedImageID)&fileType=image/png&filename=\(key)&key=\(key)"
        let AppURL = URL(string: appPath)
        if let AppURL = AppURL, UIApplication.shared.canOpenURL(URL(string: "\(KualiteeSDKConstants.deepLinkId)://")!) {
            completionHandler(true)
            print("can open kualitee application now")
            UIApplication.shared.open(AppURL, options: [:], completionHandler: { (success) in
            })
        } else {
            completionHandler(false)
            print("can't open kualitee application")
            // redirect to appstore for application download purpose
//            fatalError("can't open second app")
        }
    }
    
    /// Takes the screenshot of the screen and returns the corresponding image
    ///
    /// - Parameter shouldSave: Boolean flag asking if the image needs to be saved to user's photo library. Default set to 'true'
    /// - Returns: (Optional)image captured as a screenshot
    final private class func takeScreenshot(_ shouldSave: Bool = false) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
}
