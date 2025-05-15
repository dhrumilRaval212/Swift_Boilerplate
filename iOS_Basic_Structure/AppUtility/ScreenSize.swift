//
//  ScreenSize.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil Raval on 15/01/24.
//

import Foundation
import UIKit

//MARK:- Screen resolution
struct ScreenSize {
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var heightAspectRatio: CGFloat {
        return UIScreen.main.bounds.size.height / 667
    }
    
    static var widthAspectRatio: CGFloat {
        return UIScreen.main.bounds.size.width / 375
    }
    
    static var fontAspectRatio : CGFloat {
        if UIDevice().userInterfaceIdiom == .pad {
            return UIScreen.main.bounds.size.height / 667
        }
        
        let size = UIScreen.main.bounds.size
        
        if UIApplication.shared.statusBarOrientation.isPortrait {//Potrait
            return UIScreen.main.bounds.size.width / 375
            
        } else {//Landscape
            return UIScreen.main.bounds.size.height / 375
        }
    }
    
    static var cornerRadious: CGFloat {
        return 10
    }
}
