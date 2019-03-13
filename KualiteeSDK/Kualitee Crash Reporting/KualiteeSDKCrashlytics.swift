//
//  KualiteeSDKCrashlytics.swift
//  KualiteeSDKSwift
//
//  Created by VF on 06/03/2019.
//  Copyright © 2019 VF. All rights reserved.
//

import Foundation

internal class KualiteeSDKCrashlytics {
    
    private init() {}
    
    public class func configure() {
        KualiteeSDKCrashlytics.registerForCrashReporting()
    }
    
    private class func registerForExceptions() {
        NSSetUncaughtExceptionHandler { exception in
            print(exception.callStackReturnAddresses)
            print(exception.callStackSymbols)
            print(exception.name)
            print(exception.reason ?? "")
            print(exception.userInfo ?? [:])
        }
    }
    
    private class func registerForSignals() {
        signal(SIGABRT) { _ in
            print(Thread.callStackSymbols)
        }
        
        signal(SIGILL) { _ in
            print(Thread.callStackSymbols)
        }
        
        signal(SIGSEGV) { _ in
            print(Thread.callStackSymbols)
        }
        
        signal(SIGFPE) { _ in
            print(Thread.callStackSymbols)
        }
        
        signal(SIGBUS) { _ in
            print(Thread.callStackSymbols)
        }
        
        signal(SIGPIPE) { _ in
            print(Thread.callStackSymbols)
        }
    }
    
    private class func registerForCrashReporting() {
        registerForExceptions()
        registerForSignals()
    }
}
