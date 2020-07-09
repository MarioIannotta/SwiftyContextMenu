//
//  ContextMenuDelegate.swift
//  ContextMenu
//
//  Created by Mario Iannotta on 09/07/2020.
//

import Foundation

public protocol ContextMenuDelegate: class {

    func contextMenuWillAppear(_ contextMenu: ContextMenu)
    func contextMenuDidAppear(_ contextMenu: ContextMenu)
}

public extension ContextMenuDelegate {

    func contextMenuWillAppear(_ contextMenu: ContextMenu) { }
    func contextMenuDidAppear(_ contextMenu: ContextMenu) { }
}
