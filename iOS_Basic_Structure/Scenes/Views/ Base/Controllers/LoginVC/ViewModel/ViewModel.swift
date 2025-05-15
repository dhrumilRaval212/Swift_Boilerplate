//
//  ViewModel.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil Raval on 30/04/24.
//

import Foundation
protocol DataDelegate {
    func getCountryList(_ result: CountryModel?, error: APIError?)
    func getStateList(_ result: CountryModel?, error: APIError?)
}

class ViewModel {
    var dataDelegate : DataDelegate?
    
    func getObjects() {
        let request = APIManager.getObjects
        APIClient.shared.requestObject(request) { (countryList : CountryModel) in
            self.dataDelegate?.getCountryList(countryList, error: nil)
        } errorBlock: { error in
            self.dataDelegate?.getCountryList(nil, error: error)
        }
    }
    
    func getPostObject(params: [String:Any]) {
        let request = APIManager.postObject(param: params)
        APIClient.shared.requestObject(request) { (stateList : CountryModel) in
            self.dataDelegate?.getStateList(stateList, error: nil)
        } errorBlock: { error in
            self.dataDelegate?.getStateList(nil, error: error)
        }
    }
}
