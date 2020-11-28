//
//  UIView+.swift
//  ContextMenu
//
//  Created by Mario Iannotta on 14/06/2020.
//

import Foundation

extension UIView {

    var absoluteFrame: CGRect {
        UIApplication.shared.delegate?.window.flatMap { convert(bounds, to: $0) } ?? .zero
    }

    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func fill(with subview: UIView, insets: UIEdgeInsets = .zero) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: insets.right),
            subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: insets.bottom)])
    }
    
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return traitCollection.userInterfaceStyle == .dark
        } else {
            return false
        }
    }
}
