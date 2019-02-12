//
//  SettingScreen.swift
//  DemoLocalAuthentication
//
//  Created by Gaurang Lathiya on 12/02/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit

public enum AuthTime: Int {
    case immediately
    case oneMinute
    case fiveMinute
    
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
        case .fiveMinute:
            return "After 5 minutes"
        }
    }
    
    // touchIDAuthenticationAllowableReuseDuration::
    ///             The maximum supported interval is 5 minutes and setting the value beyond 5 minutes does not increase
    ///             the accepted interval.
    
    var timeInterval: TimeInterval {
        switch self {
        case .immediately:
            return 0
        case .oneMinute:
            return TimeInterval(exactly: 1 * 60) ?? 1 * 60
        case .fiveMinute:
            return TimeInterval(exactly: 1 * 60) ?? 5 * 60
        }
    }
}

class SettingScreen: UITableViewController {
    
    let footerView: SettingPermissionFooterView = SettingPermissionFooterView.fromNib()
    var isLocalAuthenticationEnable: Bool = UserDefaults.standard.bool(forKey: Constants.kUD_Authentication)
    var selectedAuthTime: AuthTime = AuthTime(rawValue: UserDefaults.standard.integer(forKey: Constants.kUD_Auth_Time)) ?? .immediately

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register tablefooter
        let nib = UINib(nibName: String(describing: SettingPermissionFooterView.self), bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: SettingPermissionFooterView.self))
        
        // Set Dynamic cell height
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        // Set Dynamic footer height
        self.tableView.sectionFooterHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionFooterHeight = 50;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = (Utility.isFaceIDSupported() == true) ? Constants.kFaceId : Constants.kTouchId
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (self.isLocalAuthenticationEnable == true) ? 2: 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return AuthTime.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell: SettingPermissionCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingPermissionCell.self)
                , for: indexPath) as? SettingPermissionCell {
                cell.lblTitle.text = Constants.getCellTitle()
                cell.switchPermission.isOn = self.isLocalAuthenticationEnable
                cell.switchPermission.addTarget(self, action: #selector(self.changeStatus(_:)), for: .valueChanged)
                return cell
            }
        case 1:
            if let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingAuthTimeCell") {
                let authTimeCurrent = AuthTime(rawValue: indexPath.row) ?? .immediately
                cell.textLabel?.text = authTimeCurrent.string
                cell.accessoryType =  (authTimeCurrent == selectedAuthTime) ? .checkmark : .none
                return cell
            }
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 30.0
        default:
            return 0.1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return UITableView.automaticDimension
        default:
            return 0.1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            self.selectedAuthTime =  AuthTime(rawValue: indexPath.row) ?? .immediately
            // save this entry in user default
            UserDefaults.standard.set(self.selectedAuthTime.rawValue, forKey: Constants.kUD_Auth_Time)
            UserDefaults.standard.synchronize()
            
            // Set authentication time for next interval
            AccessControl.shared.context.touchIDAuthenticationAllowableReuseDuration = self.selectedAuthTime.timeInterval
            
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integersIn: 1...1)
                    , with: UITableView.RowAnimation.none)
            }
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            if let footerView: SettingPermissionFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: SettingPermissionFooterView.self)) as? SettingPermissionFooterView {
                footerView.lblPermission?.text = Constants.getFooterInstruction()
                return footerView
            }
        default:
            break
        }
        return UIView()
    }
    
    // MARK: - Switch action
    @objc func changeStatus(_ sender: UISwitch) {
        self.isLocalAuthenticationEnable = sender.isOn
        
        // save this entry in user default
        UserDefaults.standard.set(sender.isOn, forKey: Constants.kUD_Authentication)
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
