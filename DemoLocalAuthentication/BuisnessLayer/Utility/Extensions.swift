//
//  Extensions.swift
//  DemoLocalAuthentication
//
//  Created by Gaurang Lathiya on 12/02/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension UIViewController {
    
    func topMostViewController() -> UIViewController {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
            // Handling UIViewController's added as subviews to some other views.
        else {
            for view in self.view.subviews
            {
                // Key property which most of us are unaware of / rarely use.
                if let subViewController = view.next {
                    if subViewController is UIViewController {
                        let viewController = subViewController as! UIViewController
                        return viewController.topMostViewController()
                    }
                }
            }
            return self
        }
    }
    
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let uiAlertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle:.alert)
            
            uiAlertController.addAction(
                UIAlertAction.init(title: Constants.kAlertTypeOK, style: .default, handler: { (UIAlertAction) in
                    uiAlertController.dismiss(animated: true, completion: nil)
                }))
            self.topMostViewController().present(uiAlertController, animated: true, completion: nil)
        }
    }
}
