//
//  ContextMenuActionTableViewCell.swift
//  ContextMenu
//
//  Created by Mario Iannotta on 14/06/2020.
//

import UIKit

class ContextMenuActionTableViewCell: UITableViewCell {
    
    private var rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    private var lightSelectedBackgroundView: UIVisualEffectView!
    private var darkSelectedBackgroundView: UIView!
    private var separatorView: ContextMenuSeparatorView!
    private var style: ContextMenuUserInterfaceStyle = .light {
        didSet {
            updateSelectedBackgroundView()
            separatorView.style = style
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        rightImageView.contentMode = .scaleAspectFit
        accessoryView = rightImageView
        
        prepareSelectedBackgroundView()
        
        separatorView = ContextMenuSeparatorView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0.33), style: self.style)
        addSubview(separatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSelectedBackgroundView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateSelectedBackgroundView()
    }
    
    func configure(action: ContextMenuAction, with style: ContextMenuUserInterfaceStyle) {
        textLabel?.text = action.title
        textLabel?.numberOfLines = 0
        rightImageView.image = action.image?.withRenderingMode(.alwaysTemplate)
        
        self.style = style
        switch style {
        case .automatic:
            textLabel?.textColor = action.tintColor
            rightImageView.tintColor = action.tintColor
        case .light:
            textLabel?.textColor = action.tintColor
            rightImageView.tintColor = action.tintColor
        case .dark:
            textLabel?.textColor = action.tintColorDark
            rightImageView.tintColor = action.tintColorDark
        }
    }
    
    fileprivate func prepareSelectedBackgroundView() {
        let separatorView = SeparatorView(frame: bounds)
        separatorView.alpha = 0.7
        lightSelectedBackgroundView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light)))
        lightSelectedBackgroundView.frame = bounds
        lightSelectedBackgroundView.contentView.addSubview(separatorView)
        
        darkSelectedBackgroundView = UIView(frame: bounds)
        darkSelectedBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
    
    private func updateSelectedBackgroundView() {
        darkSelectedBackgroundView.bounds = bounds
        lightSelectedBackgroundView.bounds = bounds
        lightSelectedBackgroundView.contentView.subviews.first?.frame = bounds
        
        switch style {
        case .automatic:
            selectedBackgroundView = isDarkMode ? darkSelectedBackgroundView : lightSelectedBackgroundView
        case .light:
            selectedBackgroundView = lightSelectedBackgroundView
        case .dark:
            selectedBackgroundView = darkSelectedBackgroundView
        }
    }
}
