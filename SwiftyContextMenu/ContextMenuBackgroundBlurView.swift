//
//  ContextMenuBackgroundBlurView.swift
//  SwiftyContextMenu
//
//  Created by Paul Bancarel on 28/11/2020.
//

class ContextMenuBackgroundBlurView: ContextMenuBlurView {
    
    override class var intensity: CGFloat { 0.25 }
    
    override class func blurEffect(_ style: ContextMenuUserInterfaceStyle) -> UIVisualEffect {
        switch style {
        case .automatic:
            return UIBlurEffect(style: .light)
        case .light:
            if #available(iOS 13.0, *) {
                return UIBlurEffect(style: .light)
            } else {
                return UIBlurEffect(style: .extraLight)
            }
        case .dark:
            return UIBlurEffect(style: .dark)
        }
    }
}
