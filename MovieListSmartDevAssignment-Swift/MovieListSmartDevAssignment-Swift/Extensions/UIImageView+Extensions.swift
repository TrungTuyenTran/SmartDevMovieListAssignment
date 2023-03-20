//
//  UIImageView+Extensions.swift
//  MovieListSmartDevAssignment-Swift
//
//  Created by Tran Tuyen on 20/03/2023.
//

import UIKit

extension UIImageView {
    func setImage(_ urlString: String, animate: Bool = true) {
        guard let url = URL(string: urlString) else { return }
        if let data = UserDefaults.standard.data(forKey: urlString) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                    self?.alpha = 0
                    UIView.animate(withDuration: 0.3) {
                        self?.alpha = 1
                    }
                }
            }
        } else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    UserDefaults.standard.set(data, forKey: urlString)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                            self?.alpha = 0
                            UIView.animate(withDuration: 0.3) {
                                self?.alpha = 1
                            }
                        }
                    }
                }
            }
        }
    }
}
