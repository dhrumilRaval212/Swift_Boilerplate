//
//  Extension+General.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil Raval on 30/04/24.
//

import UIKit


extension Storyboard {
    static var Main = UIStoryboard(name: Storyboard.main, bundle: nil)
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIColor {
    convenience init(Red red: Int,Green green: Int,Blue blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(Hexcode rgb: Int) {
        self.init(
            Red: (rgb >> 16) & 0xFF,
            Green: (rgb >> 8) & 0xFF,
            Blue: rgb & 0xFF
        )
    }
    var hexCode : String {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb:Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension Dictionary {
    var encodeQuery : String {
        if let dictList : [String:Any] = self as? [String:Any] {
        let queryEncode = dictList.map({ (param) -> String in
            var value = param.value
            if let isBool = value as? Bool {
                value = isBool.hashValue
            }
            let strParam = param.key + "=" + "\(value)"
            return strParam
        }).joined(separator: "&")
            
        return queryEncode
        } else {
            return ""
        }
    }
}

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}

extension UITextField {
    func addBottomBorder(color : UIColor = UIColor.black) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = color.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
