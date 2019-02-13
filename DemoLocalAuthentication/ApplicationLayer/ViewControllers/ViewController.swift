//
//  ViewController.swift
//  DemoLocalAuthentication
//
//  Created by Gaurang Lathiya on 12/02/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var lblResults: UILabel!
    @IBOutlet weak var imgViewResult: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.resetUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.handleAuthentication()
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
        
        if AccessControl.isAuthenticationSupported() {
            if let settingScreen: SettingScreen = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SettingScreen.self)) as? SettingScreen {
                self.navigationController?.pushViewController(settingScreen, animated: true)
            }
        } else {
            self.showAlert(withTitle: Constants.kApplicationName, message: Constants.kErrorOldDevice)
        }
    }
    
    func resetUI() {
        DispatchQueue.main.async {
            self.setUI(withImage: nil, message: "")
        }
    }
    
    func setUI(withImage image: UIImage?, message: String) {
        self.imgViewResult.image = image
        self.lblResults.text = message
    }
    
    func handleAuthentication() {
        
        let authState: AuthenticationState = self.isAuthenticationRequired()
        switch authState {
        case .logOut:
            self.authenticateUser()
        default:
            DispatchQueue.main.async {
                self.setUI(withImage: authState.image, message: authState.message)
            }
        }
    }
    
    // MARK: - Helper Methods
    func isAuthenticationRequired() -> AuthenticationState {
        
        if AccessControl.isAuthenticationSupported() {
            
            if UserDefaults.standard.bool(forKey: Constants.kUD_Authentication) {
                // App is set up properly
                let selectedAuthTime: AuthTime = AuthTime(rawValue: UserDefaults.standard.integer(forKey: Constants.kUD_Auth_Time)) ?? .immediately
                switch selectedAuthTime {
                case .immediately:
                    return AuthenticationState.logOut
                default:
                    if let lastAuthTime = UserDefaults.standard.object(forKey: Constants.kUD_Auth_LastDateTime) as? Date {
                        if self.getTimeDifference(fromDate: lastAuthTime) > selectedAuthTime.timeInterval {
                            return AuthenticationState.logOut
                        } else {
                            return AuthenticationState.loggedIn
                        }
                    } else {
                        return AuthenticationState.loggedIn
                    }
                }
            } else {
                return AuthenticationState.notEnrolled
            }
        } else {
            return AuthenticationState.notSupported
        }
    }
    
    func getTimeDifference(fromDate date: Date) -> Int {
        let cal = Calendar.current
        let currentDateTime = Date()
        let components = cal.dateComponents([.minute], from: date, to: currentDateTime)
        return components.minute ?? 0
    }
    
    // MARK: - Main Function
    func authenticateUser() {
        
        AccessControl.shared.evalute { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    self.setUI(withImage: AuthenticationState.loggedIn.image, message: AuthenticationState.loggedIn.message)
                }
            } else {
                var errorStr: String?
                if let error = evaluateError {
                    if error.code == LAError.userCancel || error.code == LAError.systemCancel {
                        errorStr = "Time to log out from App."
                    } else {
                        errorStr = AccessControl.shared.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code)
                    }
                }
                DispatchQueue.main.async {
                    self.setUI(withImage: UIImage.init(named: "angry"), message: errorStr ?? "Sorry!!... failed not authenticate")
                }
            }
        }
    }
}

