//
//  ContextMenuBlurView.swift
//  SwiftyContextMenu
//
//  Created by Paul Bancarel on 28/11/2020.
//

final class ContextMenuBlurView : IntensityVisualEffectView {
    
    private let style: ContextMenuUserInterfaceStyle
    
    init(_ style: ContextMenuUserInterfaceStyle) {
        self.style = style
        super.init(effect: ContextMenuBlurView.blurEffect(style), intensity: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        effect = ContextMenuBlurView.blurEffect(style)
    }
    
    fileprivate static func blurEffect(_ style: ContextMenuUserInterfaceStyle) -> UIBlurEffect {
        switch style {
        case .automatic:
            if #available(iOS 13.0, *) {
                return UIBlurEffect(style: .systemMaterial)
            } else {
                fatalError("Cannot have an automatic blur effect below iOS 13.")
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
