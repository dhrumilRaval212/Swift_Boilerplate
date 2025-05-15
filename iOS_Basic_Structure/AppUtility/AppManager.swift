//
//  AppManager.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil Raval on 30/04/24.
//

import Foundation
import UIKit

enum AppStatusType : Int {
    case production
    case staging
    case development
}

class AppManager : NSObject {
    static let shared = AppManager()
    var appStatus : AppStatusType = .development
    var authToken : String?
    var uniqueID : String {
        return NSUUID().uuidString
    }
    
    // MARK: - Members
       override init() {
           super.init()
//           self.readToken()
       }
}

extension AppManager {
    // MARK: - App Info
    struct AppInfo {
        static let AppBundleID     : String = Bundle.main.bundleIdentifier ?? ""
    }
    
    struct DeviceInfo {
        static let DeviceUDID      = UIDevice.current.identifierForVendor?.uuidString ?? ""
        static let DeviceOSVersion = UIDevice.current.systemVersion
        static let DeviceType      = UIDevice.current.model
    }
    
    /// Loads the environment plist file.
    ///
    /// - Returns: A dictionary containing environment configuration, or nil if the plist can't be loaded.
    static func loadEnvironmentPlist() -> [String: AnyObject]? {
        guard let path = Bundle.main.path(forResource: "env", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            return nil
        }
        return dict
    }
}

extension AppManager {
    func showAlert(Title strTitle: String, Message strMsg: String, ButtonTitle strBtnTitle: String, ViewController VC: UIViewController,Back back:Bool? = false) {
        let alert = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: strBtnTitle, style: .default) { (_) in
            if back ?? false {
                VC.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            VC.present(alert, animated: true)
        }
    }
}
extension AppManager {
    static func readJSONFromFile(fileName: String) -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                return data
                //json = try? JSONSerialization.jsonObject(with: data)
            } catch {
                // Handle error here
            }
        }
        return nil
    }
}
