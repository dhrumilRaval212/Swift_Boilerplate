//
//  ViewModel.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil Raval on 30/04/24.
//

import Foundation
import Combine

class ViewModel {
    private var cancellable: AnyCancellable?
    var showAlert:Bool = false
    var errorMessage = ""
    
    
    func getObjectsList(completion: @escaping ([DeviceData]) -> Void) {
        let request = APIManager.getObjects
        LoaderManager.shared.showLoader()
        cancellable = APIClient.shared.requestObjectPublisher(request)
            .sink(receiveCompletion: { completion in
                DispatchQueue.main.async {
                    LoaderManager.shared.hideLoader()
                }
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case .noData:
                                break
                            case .unAuthorized(let _):
                                //Logout
                                break
                            default:
                                self.errorMessage = error.localizedDescription
                                self.showAlert = true
                        }
                }
            }, receiveValue: { (response: [DeviceData]) in
                DispatchQueue.main.async {
                    LoaderManager.shared.hideLoader()
                }
                if !response.isEmpty {
                    completion(response)
                }
                //Success
                
                //                if response.success ?? false  {
                //                    debugtPrint("Perform Success handling")
                //                } else {
                //                    self.errorMessage = AppMessages.somethingWentWrong
                //                    self.showAlert = true
                //                }
            })
    }
    
    func cancelLoading() {
        cancellable?.cancel()
        LoaderManager.shared.hideLoader()
    }
    
    func postObject(params: [String:Any]) {
        let request = APIManager.postObject(param: params)
    }
}
