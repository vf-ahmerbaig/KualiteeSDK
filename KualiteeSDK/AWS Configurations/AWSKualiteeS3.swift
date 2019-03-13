//
//  AWSKualiteeS3.swift
//  KualiteeSDKSwift
//
//  Created by VF on 08/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSS3

typealias callBackToSDKHandler = (Bool, Error?) -> ()

class AWSKualiteeS3 {
    
    private init() {}
    
        private static let Bucket_Name: String = "kualitee-mobile-resources"
//    private static let Bucket_Name: String = "ypdistaging"
    
    
        private static let Pool_Region = AWSRegionType.USWest2
//    private static let Pool_Region = AWSRegionType.EUWest1
    
        private static let Service_Region = AWSRegionType.USWest2
//    private static let Service_Region = AWSRegionType.EUWest1
    
    
//        private static let AWS_POOL_ID: String = "eu-west-1:8e0e3023-95c9-4b19-b6bd-b81c468ea258"
    private static let AWS_POOL_ID: String = "us-west-2:12990cdc-643d-46f2-af9b-c904198b0cd1"
    
    final internal class func configure() {
        
        //Setup credentials, see your awsconfiguration.json for the "YOUR-IDENTITY-POOL-ID"
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: Pool_Region, identityPoolId: AWS_POOL_ID)
        
        //Setup the service configuration
        let configuration = AWSServiceConfiguration(region: Service_Region, credentialsProvider: credentialProvider)
        
        AWSServiceManager.default()?.defaultServiceConfiguration = configuration
    }
    
    final internal class func uploadImageFileToBucket(image: UIImage, callBackHandler: @escaping callBackToSDKHandler) {
        guard let data: Data = image.pngData() else {return}
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                print(progress.fractionCompleted)
                // Do something e.g. Update a progress bar.
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let err = error {
                    print(err.localizedDescription)
                    callBackHandler(false, err)
                } else {
                    callBackHandler(true, nil)
                }
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data,
                                   bucket: Bucket_Name,
                                   key: "ss.png",
                                   contentType: "image/png",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> Any? in
                                    if let err = task.error {
                                        print("Error: \(err.localizedDescription)")
                                        callBackHandler(false, err)
                                    }
                                    if let res = task.result {
                                        print(res)
                                        // Do something with uploadTask.
                                    }
                                    return nil
        }
    }
}
