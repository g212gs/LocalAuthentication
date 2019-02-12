//
//  Utility.swift
//  DemoLocalAuthentication
//
//  Created by Gaurang Lathiya on 12/02/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit
import LocalAuthentication

class Utility: NSObject {

    class var sharedInstance: Utility
    {
        //creating Shared Instance
        struct Static
        {
            static let instance: Utility = Utility()
        }
        return Static.instance
    }
    
    static func isFaceIDSupported() -> Bool {
        if #available(iOS 11.0, *) {
            let localAuthenticationContext = LAContext()
            if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                return localAuthenticationContext.biometryType == .faceID
            }
        }
        return false
    }
    
    static func isAuthenticationSupported() -> Bool {
        if #available(iOS 11.0, *) {
            let localAuthenticationContext = LAContext()
            if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                if #available(iOS 11.2, *) {
                    return localAuthenticationContext.biometryType != .none
                } else {
                    return localAuthenticationContext.biometryType != .LABiometryNone
                }
            }
        }
        return false
    }
    
//    static func saveCustomObject(_ object: Any, forKey strKey: String) {
//        let prefs = UserDefaults.standard
//        let myEncodedObject = NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
////        let myEncodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
//        prefs.set(myEncodedObject, forKey: strKey)
//        UserDefaults.standard.synchronize()
//    }
    
    
}
