//
//  ContextMenuBlurView.swift
//  SwiftyContextMenu
//
//  Created by Paul Bancarel on 28/11/2020.
//

class ContextMenuBlurView: IntensityVisualEffectView {
    
    class var intensity: CGFloat { 1.0 }
    internal let style: ContextMenuUserInterfaceStyle
    
    init(_ style: ContextMenuUserInterfaceStyle) {
        self.style = style
        super.init(
            effect: type(of: self).blurEffect(style),
            intensity: type(of: self).intensity
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        effect = type(of: self).blurEffect(style)
    }
    
    internal class func blurEffect(_ style: ContextMenuUserInterfaceStyle) -> UIVisualEffect {
        UIVisualEffect()
    }

}
