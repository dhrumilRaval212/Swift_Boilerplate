//
//  Constant.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil Raval on 15/01/24.
//

import Foundation
struct Constants {
    
    /// Base API endpoint URL. This is dynamically populated based on the environment the app is running in.
    static var baseURL : String {
        let envDict = AppManager.loadEnvironmentPlist()
        switch AppManager.shared.appStatus {
            case .development:
                return envDict?["endPoint.path"] as? String ?? ""
            case .production:
                return envDict?["production_url"] as? String ?? ""
            case .staging:
                return ""
        }
    }
    
    /// Device type string indicating iOS.
    static let deviceType = "iOS"
}

struct Storyboard {
    static let main = "Main"
}
