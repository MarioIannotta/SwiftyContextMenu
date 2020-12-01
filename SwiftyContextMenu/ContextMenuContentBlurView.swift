//
//  ContextMenuContentBlurView.swift
//  SwiftyContextMenu
//
//  Created by Paul Bancarel on 29/11/2020.
//

class ContextMenuContentBlurView: ContextMenuBlurView {
    
    override class var intensity: CGFloat { 1.0 }
    
    override class func blurEffect(_ style: ContextMenuUserInterfaceStyle) -> UIVisualEffect {
        switch style {
        case .automatic:
            if #available(iOS 13.0, *) {
                return UIBlurEffect(style: .systemMaterial)
            } else {
                print("Cannot have an automatic blur effect below iOS 13.")
                return UIBlurEffect(style: .light)
            }
        case .light:
            if #available(iOS 13.0, *) {
                return UIBlurEffect(style: .systemMaterialLight)
            } else {
                return UIBlurEffect(style: .extraLight)
            }
        case .dark:
            if #available(iOS 13.0, *) {
                return UIBlurEffect(style: .systemMaterialDark)
            } else {
                return UIBlurEffect(style: .dark)
            }
        }
    }
}
