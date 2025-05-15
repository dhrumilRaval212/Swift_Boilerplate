//
//  AddDeviceViewModel.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil on 15/05/25.
//


import Foundation
import Combine

protocol PostDataProtocol {
    func postObject(_ result: Device?, error: APIError?)
}

class AddDeviceViewModel {
    
    // MARK: - Input Properties
    var name: String = ""
    var year: String = ""
    var price: String = ""
    var cpuModel: String = ""
    var hardDiskSize: String = ""
    
    var delegate: PostDataProtocol?
    var showAlert = false
    var errorMessage = ""
    private var cancellable: AnyCancellable?
    
    // MARK: - Create Device Object
    func createDevice() -> Device? {
        guard isFormValid,
              let yearInt = Int(year),
              let priceDouble = Double(price)
        else {
            return nil
        }
        
        return Device(
            name: name,
            year: yearInt,
            price: priceDouble,
            cpuModel: cpuModel,
            hardDiskSize: hardDiskSize
        )
    }
    
    func addDevices(deviceData:Device) {
        let params: [String: Any] = [
            "name": deviceData.name,
            "year": deviceData.year ?? 0,
            "price": deviceData.price ?? 0.0,
            "CPU model": deviceData.cpuModel ?? "" ,
            "Hard disk size": deviceData.hardDiskSize ?? "",
        ]
        
        LoaderManager.shared.showLoader()
        let request = APIManager.postObject(param: params)
        cancellable = APIClient.shared.requestObjectPublisher(request)
            .sink(receiveCompletion: { completion in
                DispatchQueue.main.async {
                    LoaderManager.shared.hideLoader()
                }
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.delegate?.postObject(nil, error: error)
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
            }, receiveValue: { (response: Device) in
                DispatchQueue.main.async {
                    LoaderManager.shared.hideLoader()
                }
//                    debugPrint("Data added Successfully")
//                    debugPrint(response)
                    self.delegate?.postObject(response, error: nil)

            })
    }
}

extension AddDeviceViewModel  {
    
    // MARK: - Validation Errors (Optional)
    var nameError: String? {
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Name is required"
        }
        return nil
    }
    
    var yearError: String? {
        guard !year.isEmpty else { return "Year is required" }
        guard Int(year) != nil else { return "Year must be a number" }
        return nil
    }
    
    var priceError: String? {
        guard !price.isEmpty else { return "Price is required" }
        guard Double(price) != nil else { return "Price must be a number" }
        return nil
    }
    
    // MARK: - Form Validity
    var isFormValid: Bool {
        return nameError == nil &&
        yearError == nil &&
        priceError == nil
    }
}
