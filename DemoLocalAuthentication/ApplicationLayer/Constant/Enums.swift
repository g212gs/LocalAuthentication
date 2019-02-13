//
//  Enums.swift
//  DemoLocalAuthentication
//
//  Created by Gaurang Lathiya on 13/02/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import Foundation
import UIKit

public enum AuthTime: Int {
    case immediately
    case oneMinute
    case fifteenMinutes
    case oneHour
    
    // MARK:  Helper methods
    static let count: Int = {
        var max: Int = 0
        while let _ = AuthTime(rawValue: max) { max += 1 }
        return max
    }()
    
    var string: String {
        switch self {
        case .immediately:
            return "Immediately"
        case .oneMinute:
            return "After 1 minute"
        case .fifteenMinutes:
            return "After 15 minutes"
        case .oneHour:
            return "After 1 hour"
        }
    }
    
    var timeInterval: Int {
        switch self {
        case .immediately:
            return 0
        case .oneMinute:
            return 0
        case .fifteenMinutes:
            return 15
        case .oneHour:
            return 60
        }
    }
}

public enum AuthenticationState: Int {
    case loggedIn
    case logOut
    case notEnrolled
    case notSupported
    
    var message: String {
        switch self {
        case .loggedIn:
            return "Welcome to the application.. !!"
        case .logOut:
            return "Authentication process is pending"
        case .notEnrolled:
            return Constants.kAuthenticationDisabled
        case .notSupported:
            return Constants.kErrorOldDevice
        }
    }
    
    var image: UIImage? {
        switch self {
        case .loggedIn:
            return UIImage.init(named: "happy")
        case .logOut:
            return nil
        case .notEnrolled:
            return UIImage.init(named: "wait")
        case .notSupported:
            return UIImage.init(named: "angry")
        }
    }
    
}
