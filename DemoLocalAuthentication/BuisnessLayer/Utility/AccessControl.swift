//
//  AccessControl.swift
//  DemoLocalAuthentication
//
//  Created by Gaurang Lathiya on 12/02/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import Foundation
import LocalAuthentication

class AccessControl {
    
    // MARK: - Singleton
    public static let shared = AccessControl()
    
    // Policy
    private var policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    
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
    
    typealias evaluteResultHandler = ((Bool, Error?) -> Void)
    
    // Evaluate
    func evalute(completion: @escaping evaluteResultHandler) {        
        var authError: NSError?
        guard context.canEvaluatePolicy(policy, error:  &authError) else {
            completion(false, authError)
            return
        }
        
        context.evaluatePolicy(policy, localizedReason: reason) { success, evaluateError in
            if success {
                completion(true, authError)
            } else {
                completion(false, evaluateError)
            }
        }
    }
}
