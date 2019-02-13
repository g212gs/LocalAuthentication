//
//  Utility.swift
//  DemoLocalAuthentication
//
//  Created by Gaurang Lathiya on 12/02/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit

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
}
