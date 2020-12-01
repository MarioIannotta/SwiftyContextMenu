//
//  ContextMenu.swift
//  ContextMenu
//
//  Created by Mario Iannotta on 06/14/2020.
//  Copyright (c) 2020 Mario Iannotta. All rights reserved.
//

import UIKit

public struct ContextMenu {
    let style: ContextMenuUserInterfaceStyle
    let title: String?
    let actions: [ContextMenuAction]
    let layout: ContextMenuLayout
    let animation: ContextMenuAnimation
    weak var delegate: ContextMenuDelegate?

    var sourceViewInfo: ContextMenuSourceViewInfo?

    public init(title: String?,
                actions: [ContextMenuAction],
                style: ContextMenuUserInterfaceStyle? = nil,
                layout: ContextMenuLayout = ContextMenuLayout(),
                animation: ContextMenuAnimation = ContextMenuAnimation(),
                delegate: ContextMenuDelegate? = nil) {
        
        if #available(iOS 13, *) {
            self.style = style ?? .automatic
        } else {
            self.style = style ?? .light
        }
        self.title = title
        self.actions = actions
        self.layout = layout
        self.animation = animation
        self.delegate = delegate
    }
}

public struct ContextMenuAction {
    let title: String
    let image: UIImage?
    let tintColor: UIColor
    let tintColorDark: UIColor
    let action: ((ContextMenuAction) -> Void)?

    public init(title: String,
                image: UIImage? = nil,
                tintColor: UIColor? = nil,
                tintColorDark: UIColor? = nil,
                action: ((ContextMenuAction) -> Void)?) {
        self.title = title
        self.image = image
        self.tintColor = tintColor ?? .defaultLabelMenuActionColor
        self.tintColorDark = tintColorDark ?? .defaultLabelMenuActionColor
        self.action = action
    }
}

public enum ContextMenuEvent {
    case longPress(duration: TimeInterval)
    case tap(numberOfTaps: Int)
}

public enum ContextMenuUserInterfaceStyle {
    @available(iOS 13, *) case automatic
    case light, dark
}

public struct ContextMenuAnimation {
    let sourceViewBounceRange: ClosedRange<CGFloat>
    let optionsViewBounceRange: ClosedRange<CGFloat>
        
    public init(sourceViewBounceRange: ClosedRange<CGFloat> = 0.9...1.15,
                optionsViewBounceRange: ClosedRange<CGFloat> = 0.05...1) {
        self.sourceViewBounceRange = sourceViewBounceRange
        self.optionsViewBounceRange = optionsViewBounceRange
    }
}

public struct ContextMenuLayout {
    let width: CGFloat
    let spacing: CGFloat
    let padding: CGFloat
    let sourceViewCornerRadius: CGFloat

    public init(width: CGFloat = 250,
                spacing: CGFloat = 20,
                padding: CGFloat = 30,
                sourceViewCornerRadius: CGFloat = 0) {
        self.width = width
        self.spacing = spacing
        self.padding = padding
        self.sourceViewCornerRadius = sourceViewCornerRadius
    }
}

struct ContextMenuSourceViewInfo {
    let alpha: CGFloat
    let snapshot: UIImage?
    let originalFrame: CGRect
    let targetFrame: CGRect
}

public protocol ContextMenuSourceView: UIView { }

extension UIView: ContextMenuSourceView {

    public func addContextMenu(_ contextMenu: ContextMenu, for events: ContextMenuEvent...) {
        self.contextMenu = contextMenu
        self.contextMenuGestureRecognizers = []
        events.forEach(addGestureRecognizer)
    }

    public func removeContextMenu() {
        contextMenu = nil
        contextMenuGestureRecognizers?.forEach(removeGestureRecognizer)
        contextMenuGestureRecognizers = []
    }

    public func showContextMenu(completion: (() -> Void)?) {
        snapshotSourceView()
        guard
            let contextMenu = contextMenu
            else { return }
        alpha = 0
        contextMenuWindow = ContextMenuWindow(
            contextMenu: contextMenu,
            onDismiss: { [weak self] in
                self?.contextMenuWindow = nil
                self?.alpha = 1
            })
        contextMenuWindow?.makeKeyAndVisible()
    }

    public func dismissContextMenu(completion: (() -> Void)?) {
        contextMenuWindow?.resignKey()
    }

    func snapshotSourceView() {
        let padding = contextMenu?.layout.padding ?? 0
        let originalFrame = absoluteFrame
        let originalFrameWithPadding = CGRect(x: originalFrame.origin.x - padding,
                                              y: originalFrame.origin.y - padding,
                                              width: originalFrame.width + padding * 2,
                                              height: originalFrame.height + padding * 2)
        let targetFrame: CGRect
        if UIScreen.main.bounds.contains(originalFrameWithPadding) {
            targetFrame = originalFrame
        } else {
            let x: CGFloat
            let y: CGFloat
            if originalFrame.minX < padding {
                x = padding
            } else if originalFrame.maxX > UIScreen.main.bounds.width - padding {
                x = UIScreen.main.bounds.width - originalFrame.width - padding
            } else {
                x = originalFrame.origin.x
            }
            if originalFrame.minY < padding {
                y = padding 
            } else if originalFrame.maxY > UIScreen.main.bounds.height - padding {
                y = UIScreen.main.bounds.height - originalFrame.height - padding
            } else {
                y = originalFrame.origin.y
            }
            targetFrame = CGRect(origin: CGPoint(x: x, y: y), size: originalFrame.size)
        }
        contextMenu?.sourceViewInfo = ContextMenuSourceViewInfo(alpha: alpha,
                                                                snapshot: snapshot(),
                                                                originalFrame: originalFrame,
                                                                targetFrame: targetFrame)
    }
}
