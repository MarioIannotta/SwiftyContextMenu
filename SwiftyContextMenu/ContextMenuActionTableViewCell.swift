//
//  ContextMenuActionTableViewCell.swift
//  ContextMenu
//
//  Created by Mario Iannotta on 14/06/2020.
//

import UIKit

class ContextMenuActionTableViewCell: UITableViewCell {
    
    private let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    private let lightSelectedBackgroundView: UIVisualEffectView
    private let darkSelectedBackgroundView: UIView
    
    private var separatorView: ContextMenuSeparatorView?
    private var style: ContextMenuUserInterfaceStyle = .light {
        didSet {
            updateSelectedBackgroundView()
            separatorView?.style = style
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let separatorView = SeparatorView(frame: .zero)
        separatorView.alpha = 0.7
        lightSelectedBackgroundView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light)))
        lightSelectedBackgroundView.contentView.fill(with: separatorView)
        
        darkSelectedBackgroundView = UIView(frame: .zero)
        darkSelectedBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        textLabel?.numberOfLines = 0
        rightImageView.contentMode = .scaleAspectFit
        accessoryView = rightImageView
        addSeparatorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateSelectedBackgroundView()
    }
    
    func configure(action: ContextMenuAction, with style: ContextMenuUserInterfaceStyle) {
        textLabel?.text = action.title
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
    
    private func addSeparatorView() {
        let separatorView = ContextMenuSeparatorView(frame: .zero, style: self.style)
        self.separatorView = separatorView
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        DispatchQueue.main.async {
            NSLayoutConstraint.activate([
                separatorView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: 0.33),
                separatorView.widthAnchor.constraint(equalTo: self.widthAnchor),
                separatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
            
        }
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
