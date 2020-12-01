//
//  ContextMenuTitleLabel.swift
//  SwiftyContextMenu
//
//  Created by Paul Bancarel on 28/11/2020.
//

extension UIColor {
    
    static var defaultLabelMenuActionColor: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
}
