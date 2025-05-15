//
//  AppCordinator.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil Raval on 15/01/24.
//

import Foundation
import UIKit

class AppCoordinator: NSObject {
    
    func basicAppSetup() {
        //Application setup
        UIApplication.shared.windows.first?.isExclusiveTouch = true
        UITextField.appearance().tintColor = UIColor.black
        UITextView.appearance().tintColor = UIColor.black
        
        let alertView = UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
        alertView.tintColor = UIColor.systemBlue
        
        UINavigationBar.appearance().barStyle = .black
        
        //manage login
        if #available(iOS 13.0, *) {
            
        } else {

        }
        
        //Google sign in init
        //        GIDSignIn.sharedInstance().clientID = AppCredential.googleClientID.rawValue
        
        //Push setup
        //AppDelegate.shared.registerForNotification()
    }
}
