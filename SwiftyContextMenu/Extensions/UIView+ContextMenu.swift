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
    static var contextMenuGestureRecognizers = "ContextMenu.GestureRecognizers"
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

    var contextMenuGestureRecognizers: [UIGestureRecognizer]? {
        get { objc_getAssociatedObject(self, &ContextMenuAssociatedObjectKey.contextMenuGestureRecognizers) as? [UIGestureRecognizer] }
        set { objc_setAssociatedObject(self, &ContextMenuAssociatedObjectKey.contextMenuGestureRecognizers, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func addGestureRecognizer(event: ContextMenuEvent) {
        switch event {
        case .longPress(let duration):
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureRecognizer(_:)))
            longPressGestureRecognizer.minimumPressDuration = duration
            addGestureRecognizer(longPressGestureRecognizer)
            contextMenuGestureRecognizers?.append(longPressGestureRecognizer)
        case .tap(let numberOfTaps):
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            tapGestureRecognizer.numberOfTapsRequired = numberOfTaps
            addGestureRecognizer(tapGestureRecognizer)
            contextMenuGestureRecognizers?.append(tapGestureRecognizer)
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

extension ContextMenu {

    private var sourceViewTranslationSize: CGSize {
        guard
            let targetFrame = sourceViewInfo?.targetFrame,
            let originalFrame = sourceViewInfo?.originalFrame,
            (originalFrame.origin.x < 0
                || originalFrame.origin.y < 0
                || originalFrame.maxX > UIScreen.main.bounds.width
                || originalFrame.maxY > UIScreen.main.bounds.height)
            else {
                return .zero
            }
        let translationX = targetFrame.midX - originalFrame.midX
        let translationY = targetFrame.midY - originalFrame.midY
        return CGSize(width: translationX, height: translationY)
    }

    private var sourceViewTranslationTransform: CGAffineTransform {
        return CGAffineTransform(translationX: sourceViewTranslationSize.width,
                                 y: sourceViewTranslationSize.height)
    }

    var sourceViewFirstStepTransform: CGAffineTransform {
        CGAffineTransform(scaleX:  animation.sourceViewBounceRange.lowerBound,
                          y: animation.sourceViewBounceRange.lowerBound)
            .concatenating(sourceViewTranslationTransform)
    }

    var sourceViewSecondTransform: CGAffineTransform {
        let middlePoint = (animation.sourceViewBounceRange.upperBound - animation.sourceViewBounceRange.lowerBound) / 2
        let scale = animation.sourceViewBounceRange.lowerBound + middlePoint
        return CGAffineTransform(scaleX: scale, y: scale)
            .concatenating(sourceViewTranslationTransform)
    }
    
    func sourceViewThirdTransform(isContextMenuUp: Bool, isContextMenuRight: Bool) -> CGAffineTransform {
        guard
            let targetFrame = sourceViewInfo?.targetFrame
            else {
                return sourceViewTranslationTransform
            }
        let scaleTransform = CGAffineTransform(scaleX: animation.sourceViewBounceRange.upperBound,
                                               y: animation.sourceViewBounceRange.upperBound)
        let finalSnapshotSize = targetFrame.applying(scaleTransform)
        var translationX = (targetFrame.size.width - finalSnapshotSize.size.width) / 2
        var translationY = (targetFrame.size.height - finalSnapshotSize.size.height) / 2
        if !isContextMenuUp { translationY *= -1 }
        if !isContextMenuRight { translationX *= -1 }
        return scaleTransform.translatedBy(x: sourceViewTranslationSize.width + translationX,
                                           y: sourceViewTranslationSize.height + translationY)

    }

    func optionsViewFirstTransform(isContextMenuUp: Bool) -> CGAffineTransform {
        sourceViewTranslationTransform
            .concatenating(
                CGAffineTransform(
                    scaleX: animation.optionsViewBounceRange.lowerBound,
                    y: animation.optionsViewBounceRange.lowerBound
                )
            )
            .concatenating(
                CGAffineTransform(
                    translationX: 0,
                    y: (!isContextMenuUp ? -1 : 1) * 120
                )
            )
    }
    
    var optionsViewSecondTransform: CGAffineTransform {
        CGAffineTransform(scaleX: animation.optionsViewBounceRange.upperBound,
                          y: animation.optionsViewBounceRange.upperBound)
            .concatenating(sourceViewTranslationTransform)
    }

    var optionsViewThirdTransform: CGAffineTransform {
        sourceViewTranslationTransform
    }
}
