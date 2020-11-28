//
//  ContextMenuTableView.swift
//  ContextMenu
//
//  Created by Mario Iannotta on 14/06/2020.
//

import UIKit

class ContextMenuTableView: UITableView {

    init() {
        super.init(frame: .zero, style: .plain)
        separatorInset = .zero
        separatorStyle = .none
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var contentSize: CGSize {
        didSet {
            guard
                contentSize != oldValue
                else { return }
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        isScrollEnabled = contentSize.height > bounds.height
    }
}
