//
//  Constants.swift
//  DemoLocalAuthentication
//
//  Created by Gaurang Lathiya on 12/02/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit

class Constants: NSObject {

    //application constant
    static let kApplicationName         =   "Local Authentication"
    
    static let SCREEN_SIZE: CGRect      =   UIScreen.main.bounds
    
    //AlertTitle Constants
    static let kAlertTypeOK             =   "OK"
    static let kAlertTypeCancel         =   "Cancel"
    static let kAlertTypeYES            =   "YES"
    static let kAlertTypeNO             =   "NO"
    
    static let kTouchId                 =   "Touch ID"
    static let kFaceId                  =   "Face ID"
    
    static let kNoAuthenticationResult  =   "Please turn on authentication in order to check the result."
    
    //User Defaults
    static let kUD_Authentication       =   "authentication"
    static let kUD_Auth_Time            =   "auth_time"
    
    // App Required instructions
    static func getLocalizedReasonString() -> String {
        let dynamicStr = (Utility.isFaceIDSupported() == true) ? Constants.kFaceId : Constants.kTouchId
        return dynamicStr + " is required to use \(Constants.kApplicationName)."
    }
    
    static func getFooterInstruction() -> String {
        let dynamicStr = (Utility.isFaceIDSupported() == true) ? Constants.kFaceId : Constants.kTouchId
        return "When enabled, you'll need to user \(dynamicStr) to unlock \(Constants.kApplicationName). You can still answer calls if \(Constants.kApplicationName) is locked."
    }
    
    static func getCellTitle() -> String {
        return "Require " + ((Utility.isFaceIDSupported() == true) ? Constants.kFaceId : Constants.kTouchId)
    }
    
    // Errors
    static let kErrorOldDevice          =   "Ooops!!.. Your device is not supported to authenticate via Face ID or Touch ID."
    
}
