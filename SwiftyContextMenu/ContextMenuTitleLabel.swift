//
//  ContextMenuTitleLabel.swift
//  SwiftyContextMenu
//
//  Created by Paul Bancarel on 28/11/2020.
//

class ContextMenuTitleLabel: UILabel {
    
    private let style: ContextMenuUserInterfaceStyle
    private let darkTextColor = UIColor(red: 0.922, green: 0.922, blue: 0.961, alpha: 0.6)
    private let lightTextColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
    
    init(frame: CGRect, style: ContextMenuUserInterfaceStyle) {
        self.style = style
        super.init(frame: frame)
        font = UIFont.preferredFont(forTextStyle: .footnote)
        adjustsFontForContentSizeCategory = true
        textAlignment = .center
        updateTextColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateTextColor()
    }
    
    private func updateTextColor() {
        switch style {
        case .automatic:
            textColor = isDarkMode ? darkTextColor : lightTextColor
        case .light:
            textColor = lightTextColor
        case .dark:
            textColor = darkTextColor
        }
    }
}
