//
//  LoadingIndicator.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/19.
//

import Foundation
import UIKit
class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else {
                return
            }
            
            let loadingindicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: {
                $0 is UIActivityIndicatorView
            }) as? UIActivityIndicatorView {
                loadingindicatorView = existedView
            } else {
                loadingindicatorView = UIActivityIndicatorView(style: .large)
                loadingindicatorView.frame = window.frame
                loadingindicatorView.color = .systemRed
                loadingindicatorView.layer.opacity = 0.5
                loadingindicatorView.backgroundColor = .gray
                window.addSubview(loadingindicatorView)
            }
            
            loadingindicatorView.startAnimating()
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView}).forEach({ $0.removeFromSuperview()})
        }
    }
}
