//
//  UIView+ContextMenu.swift
//  ContextMenu
//
//  Created by Mario Iannotta on 14/06/2020.
//

import UIKit

private struct ContextMenuAssociatedObjectKey {
    static var contextMenu = "ContextMenu.ContextMenu"
    static var contextMenuWindow = "ContextMenu.ContextMenuWindow"
}

extension UIView {

    var contextMenu: ContextMenu? {
        get { objc_getAssociatedObject(self, &ContextMenuAssociatedObjectKey.contextMenu) as? ContextMenu }
        set { objc_setAssociatedObject(self, &ContextMenuAssociatedObjectKey.contextMenu, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var contextMenuWindow: ContextMenuWindow? {
        get { objc_getAssociatedObject(self, &ContextMenuAssociatedObjectKey.contextMenuWindow) as? ContextMenuWindow }
        set { objc_setAssociatedObject(self, &ContextMenuAssociatedObjectKey.contextMenuWindow, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func addGestureRecognizer(event: ContextMenuEvent) {
        switch event {
        case .longPress(let duration):
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureRecognizer(_:)))
            longPressGestureRecognizer.minimumPressDuration = duration
            addGestureRecognizer(longPressGestureRecognizer)
        case .tap(let numberOfTaps):
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            tapGestureRecognizer.numberOfTapsRequired = numberOfTaps
            addGestureRecognizer(tapGestureRecognizer)
        }
    }

    @objc private func handleLongPressGestureRecognizer(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        guard
            longPressGestureRecognizer.state == .began
            else { return }
        showContextMenu(completion: nil)
    }

    @objc private func handleTapGestureRecognizer(_ tapGestureRecognizer: UITapGestureRecognizer) {
        guard
            tapGestureRecognizer.state == .ended
            else { return }
        showContextMenu(completion: nil)
    }
}

extension ContextMenuAnimation {

    var sourceViewFirstStepTransform: CGAffineTransform {
        CGAffineTransform(scaleX: sourceViewBounceRange.lowerBound, y: sourceViewBounceRange.lowerBound)
    }

    var sourceViewSecondTransform: CGAffineTransform {
        let scale = sourceViewBounceRange.lowerBound + (sourceViewBounceRange.upperBound - sourceViewBounceRange.lowerBound)/2
        return CGAffineTransform(scaleX: scale, y: scale)
    }
    var sourceViewThirdTransform: CGAffineTransform {
        CGAffineTransform(scaleX: sourceViewBounceRange.upperBound, y: sourceViewBounceRange.upperBound)
    }

    var optionsViewFirstTransform: CGAffineTransform {
        CGAffineTransform(scaleX: optionsViewBounceRange.lowerBound, y: optionsViewBounceRange.lowerBound)
    }

    var optionsViewSecondTransform: CGAffineTransform {
        CGAffineTransform(scaleX: optionsViewBounceRange.upperBound, y: optionsViewBounceRange.upperBound)
    }
}
