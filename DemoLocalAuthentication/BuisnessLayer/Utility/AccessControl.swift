//
//  AccessControl.swift
//  DemoLocalAuthentication
//
//  Created by Gaurang Lathiya on 12/02/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import Foundation
import LocalAuthentication

open class AccessControl: NSObject {
    
    // Singleton
    public static let shared = AccessControl()
    
    // Private
    private override init() {}
    
    // Policy
//    private var policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    private var policy: LAPolicy = .deviceOwnerAuthentication

    
    // Reason
    private var reason: String = NSLocalizedString(Constants.getLocalizedReasonString(), comment: "")
    
    // Context
    lazy var context: LAContext = {
        let mainContext = LAContext()
        mainContext.touchIDAuthenticationAllowableReuseDuration = 0 // default 0 - immediate
        // Hide "Enter Password" button
        mainContext.localizedFallbackTitle = ""
        return mainContext
    }()
    
    public var allowableReuseDuration: TimeInterval = 0 {
        didSet {
            self.context.touchIDAuthenticationAllowableReuseDuration = allowableReuseDuration
        }
    }
    
    typealias evaluteResultHandler = ((Bool, LAError?) -> Void)
    
    // MARK: - Check the Authetication possibility
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
    
    // Evaluate
    func evalute(completion: @escaping evaluteResultHandler) {        
        var authError: NSError?
        guard context.canEvaluatePolicy(policy, error:  &authError) else {
            completion(false, authError as? LAError)
            return
        }
        
        context.evaluatePolicy(policy, localizedReason: reason) { success, evaluateError in
            if success {
                completion(true, nil)
            } else {
                completion(false, evaluateError as? LAError)
            }
        }
    }
    
    // MARK: - Error Handling
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = "Sorry!!... failed not authenticate"
        if #available(iOS 11.0, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = "Sorry!!... failed not authenticate due to hardware issue"
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}
