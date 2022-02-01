//
//  Extensions.swift
//  IOS Challenge - TV API
//
//  Created by Kelvin Javorski Soares on 31/01/22.
//

import UIKit

extension UIImageView {
    func load(url: String) {
        guard let url = URL(string: url) else { return }
        self.load(url: url)
    }

    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
