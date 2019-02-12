//
//  ViewController.swift
//  DemoLocalAuthentication
//
//  Created by Gaurang Lathiya on 12/02/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblResults: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.lblResults.text = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setResults()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }

    func setNavigationBar() {
        self.title = "Home"
        self.setRightBarButton()
    }
    
    func setRightBarButton() {
        // remove previous buttons
        self.navigationItem.setRightBarButtonItems([], animated: true)
        
        let rightBarBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(self.goToSettings(_:)))
        self.navigationItem.setRightBarButtonItems([rightBarBtn], animated: true)
    }
    
    @objc func goToSettings(_ sender: Any) {
        
        if Utility.isAuthenticationSupported() {
            if let settingScreen: SettingScreen = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SettingScreen.self)) as? SettingScreen {
                self.navigationController?.pushViewController(settingScreen, animated: true)
            }
        } else {
            self.showAlert(withTitle: Constants.kApplicationName, message: Constants.kErrorOldDevice)
        }
    }
    
    func setResults() {
        
        if Utility.isAuthenticationSupported() {
            
            if UserDefaults.standard.bool(forKey: Constants.kUD_Authentication) {
                
                AccessControl.shared.evalute { (success, evaluateError) in
                    var message: String = ""
                    if success {
                        message = "Awesome!!... User authenticated successfully"
                    } else {
                        var errorStr = "Sorry!!... failed not authenticate"
                        if let err = evaluateError?.localizedDescription {
                            errorStr = err
                        }
                        message = errorStr
                    }
                    DispatchQueue.main.async {
                        self.lblResults.text = message
                    }
                }
            } else {
                self.lblResults.text = Constants.kNoAuthenticationResult
            }
        } else {
            self.lblResults.text = Constants.kErrorOldDevice
        }
    }
    
}

