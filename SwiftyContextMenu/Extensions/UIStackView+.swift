//
//  ContextMenuTitleLabel.swift
//  SwiftyContextMenu
//
//  Created by Paul Bancarel on 28/11/2020.
//

extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = spacing
        self.axis = axis
    }
}
