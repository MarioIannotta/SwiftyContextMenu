//
//  ContextMenuActionTableViewCell.swift
//  ContextMenu
//
//  Created by Mario Iannotta on 14/06/2020.
//

import UIKit

class ContextMenuActionTableViewCell: UITableViewCell {

    private var rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        rightImageView.contentMode = .scaleAspectFit
        accessoryView = rightImageView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(action: ContextMenuAction) {
        textLabel?.text = action.title
        textLabel?.numberOfLines = 0
        textLabel?.textColor = action.tintColor
        rightImageView.image = action.image?.withRenderingMode(.alwaysTemplate)
        rightImageView.tintColor = action.tintColor
    }
}
