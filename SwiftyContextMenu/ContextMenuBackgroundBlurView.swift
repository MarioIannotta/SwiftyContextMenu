//
//  ContextMenuBackgroundBlurView.swift
//  SwiftyContextMenu
//
//  Created by Paul Bancarel on 28/11/2020.
//

final class ContextMenuBackgroundBlurView : IntensityVisualEffectView {
    
    private let style: ContextMenuUserInterfaceStyle
    
    init(_ style: ContextMenuUserInterfaceStyle) {
        self.style = style
        super.init(effect: ContextMenuBackgroundBlurView.blurEffect(style), intensity: 0.25)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        effect = ContextMenuBackgroundBlurView.blurEffect(style)
    }
    
    fileprivate static func blurEffect(_ style: ContextMenuUserInterfaceStyle) -> UIBlurEffect {
        switch style {
        case .automatic:
            if #available(iOS 13.0, *) {
                return UIBlurEffect(style: .light)
            } else {
                fatalError("Cannot have an automatic blur effect below iOS 13.")
            }
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
