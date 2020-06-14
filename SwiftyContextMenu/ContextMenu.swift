//
//  ContextMenu.swift
//  ContextMenu
//
//  Created by Mario Iannotta on 06/14/2020.
//  Copyright (c) 2020 Mario Iannotta. All rights reserved.
//

import UIKit

public struct ContextMenu {
    let title: String?
    let actions: [ContextMenuAction]
    let layout: ContextMenuLayout
    let animation: ContextMenuAnimation

    var sourceViewInfo: ContextMenuSourceViewInfo?

    public init(title: String,
                actions: [ContextMenuAction],
                layout: ContextMenuLayout = ContextMenuLayout(),
                animation: ContextMenuAnimation = ContextMenuAnimation()) {
        self.title = title
        self.actions = actions
        self.layout = layout
        self.animation = animation
    }
}

public struct ContextMenuAction {
    let title: String
    let image: UIImage?
    let tintColor: UIColor
    let action: ((ContextMenuAction) -> Void)?

    public init(title: String,
                image: UIImage? = nil,
                tintColor: UIColor = .black,
                action: ((ContextMenuAction) -> Void)?) {
        self.title = title
        self.image = image
        self.tintColor = tintColor
        self.action = action
    }
}

public enum ContextMenuEvent {
    case longPress(duration: TimeInterval)
    case tap(numberOfTaps: Int)
}

public struct ContextMenuAnimation {
    let sourceViewBounceRange: ClosedRange<CGFloat>
    let optionsViewBounceRange: ClosedRange<CGFloat>
        
    public init(sourceViewBounceRange: ClosedRange<CGFloat> = 0.9...1.15,
                optionsViewBounceRange: ClosedRange<CGFloat> = 0.9...1) {
        self.sourceViewBounceRange = sourceViewBounceRange
        self.optionsViewBounceRange = optionsViewBounceRange
    }
}

public struct ContextMenuLayout {
    let width: CGFloat
    let spacing: CGFloat
    let padding: CGFloat

    public init(width: CGFloat = 250, spacing: CGFloat = 20, padding: CGFloat = 40) {
        self.width = width
        self.spacing = spacing
        self.padding = padding
    }
}

struct ContextMenuSourceViewInfo {
    let alpha: CGFloat
    let snapshot: UIImage?
    let frame: CGRect
}

public protocol ContextMenuSourceView: UIView { }

extension UIView: ContextMenuSourceView {

    public func addContextMenu(_ contextMenu: ContextMenu, for events: ContextMenuEvent...) {
        self.contextMenu = contextMenu
        events.forEach(addGestureRecognizer)
    }

    public func showContextMenu(completion: (() -> Void)?) {
        snapshotSourceView()
        guard
            let contextMenu = contextMenu
            else { return }
        contextMenuWindow = ContextMenuWindow(
            contextMenu: contextMenu,
            onDismiss: { [weak self] in
                self?.closeContextMenu()
            })
        contextMenuWindow?.makeKeyAndVisible()
        alpha = 0
    }

    public func dismissContextMenu(completion: (() -> Void)?) {
        contextMenuWindow?.resignKey()
    }

    private func closeContextMenu() {
        alpha = 1
        contextMenuWindow = nil
    }

    func snapshotSourceView() {
        contextMenu?.sourceViewInfo = ContextMenuSourceViewInfo(alpha: alpha, snapshot: snapshot(), frame: absoluteFrame)
    }
}
