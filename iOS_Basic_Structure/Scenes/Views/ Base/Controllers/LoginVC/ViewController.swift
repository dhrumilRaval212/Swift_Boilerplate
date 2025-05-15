//
//  ViewController.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil Raval on 15/01/24.
//

import UIKit

class ViewController: UIViewController {
 
    private var viewModel: ViewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.dataDelegate = self
        self.viewModel.getCountryList()
    }
}

extension ViewController : DataDelegate {
    func getStateList(_ result: CountryModel?, error: APIError?) {
        guard let data = result else {
            /// Handle error here
            if let err = error, err == .noData {
                /// This block is executed if data is empty
                Alert.shared.showSnackBar(error?.localizedDescription ?? AppMessages.wentWrong)
            } else {
                Alert.shared.showSnackBar(error?.localizedDescription ?? AppMessages.wentWrong)
            }
            return
        }
        /// SUCESS:
        debugPrint(data)
    }
    
    func getCountryList(_ result: CountryModel?, error: APIError?) {
        guard let data = result else {
            /// Handle error here
            if let err = error, err == .noData {
                /// This block is executed if data is empty
                Alert.shared.showSnackBar(error?.localizedDescription ?? AppMessages.wentWrong)
            } else {
                Alert.shared.showSnackBar(error?.localizedDescription ?? AppMessages.wentWrong)
            }
            return
        }
        /// SUCESS:
        debugPrint(data)
        let params : [String:Any] = [
            "country_id": 77, // Static Code for India
        ]
        self.viewModel.getStateList(params: params)
    }
}
