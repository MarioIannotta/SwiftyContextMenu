//
//  ContextMenuSeparatorView.swift
//  SwiftyContextMenu
//
//  Created by Paul Bancarel on 28/11/2020.
//

class ContextMenuSeparatorView: UIStackView {
    var style: ContextMenuUserInterfaceStyle {
        didSet {
            updateLightDarkVisibility()
        }
    }
    private let lightView: UIView
    private let darkView: UIVisualEffectView
    
    init(frame: CGRect, style: ContextMenuUserInterfaceStyle) {
        self.style = style
        
        let separatorView = SeparatorView(frame: frame)
        darkView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark)))
        darkView.contentView.fill(with: separatorView)
        
        lightView = SeparatorView(frame: frame)
        lightView.tintColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        
        super.init(frame: frame)
        backgroundColor = .clear
        axis = .vertical
        
        addArrangedSubview(lightView)
        addArrangedSubview(darkView)
        updateLightDarkVisibility()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateLightDarkVisibility()
    }
    
    private func updateLightDarkVisibility() {
        switch style {
        case .automatic:
            lightView.isHidden = isDarkMode ? true : false
            darkView.isHidden = isDarkMode ? false : true
        case .light:
            lightView.isHidden = false
            darkView.isHidden = true
        case .dark:
            lightView.isHidden = true
            darkView.isHidden = false
        }
    }
}
