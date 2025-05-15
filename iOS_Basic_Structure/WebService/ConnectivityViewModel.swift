//
//  ConnectivityViewModel.swift
//  iOS_Basic_SwiftUI_Structure
//
//  Created by Dhrumil on 13/05/25.
//

import Combine
import Alamofire
import Foundation

/// A ViewModel that monitors the network connectivity status and notifies the view accordingly.
class ConnectivityViewModel: ObservableObject {
    
    @Published var isConnectedToInternet: Bool = true
    @Published var showNoInternetView: Bool = false

    private var reachabilityManager: NetworkReachabilityManager?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        startNetworkReachabilityObserver()
    }
    
    /// Starts the network reachability observer to monitor internet connectivity.
    /// Updates `isConnectedToInternet` and `showNoInternetView` properties based on the network status.
    private func startNetworkReachabilityObserver() {
        reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .notReachable:
                    self?.isConnectedToInternet = false
                    self?.showNoInternetView = true
                case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                    self?.isConnectedToInternet = true
                    self?.showNoInternetView = false
                case .unknown:
                    self?.isConnectedToInternet = false
                    self?.showNoInternetView = true
                }
            }
        }
    }
    
    /// Attempts to retry the connection by checking the reachability status.
    /// If the device is reachable, it hides the "No Internet" view.
    func retryConnection() {
        if let isConnected = reachabilityManager?.isReachable, isConnected {
            showNoInternetView = false
        }
    }
}
