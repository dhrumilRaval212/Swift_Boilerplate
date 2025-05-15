//
//  LoaderManager.swift
//  OC_Tracker_SwiftUI
//
//  Created by OneClick on 21/06/24.
//

import UIKit

final class LoaderManager {
    static let shared = LoaderManager()
    
    private var overlayView: UIView?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private init() {}
    
    func showLoader(on view: UIView? = nil) {
        DispatchQueue.main.async {
            guard let targetView = view ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            self.removeLoader()
            
            let overlay = UIView(frame: targetView.bounds)
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            
            self.activityIndicator.center = overlay.center
            self.activityIndicator.startAnimating()
            overlay.addSubview(self.activityIndicator)
            
            targetView.addSubview(overlay)
            self.overlayView = overlay
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.removeLoader()
        }
    }
    
    private func removeLoader() {
        activityIndicator.stopAnimating()
        overlayView?.removeFromSuperview()
        overlayView = nil
    }
}

