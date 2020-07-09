//
//  ViewController.swift
//  ContextMenu
//
//  Created by Mario Iannotta on 06/14/2020.
//  Copyright (c) 2020 Mario Iannotta. All rights reserved.
//

import UIKit
import SwiftyContextMenu

class ViewController: UIViewController {

    @IBOutlet private var uiContextMenuButtons: [UIButton]!
    @IBOutlet private var contextMenuButtons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()

        (contextMenuButtons + uiContextMenuButtons).forEach {
            $0?.layer.cornerRadius = 10
        }

        if #available(iOS 13.0, *) {
            uiContextMenuButtons.forEach {
                $0.addInteraction(UIContextMenuInteraction(delegate: self))
            }
        }

        let favoriteAction = ContextMenuAction(title: "Looooooooooooong title",
                                               image: UIImage(named: "heart.fill"),
                                               action: { _ in print("favorite") })
        let shareAction = ContextMenuAction(title: "Share",
                                            image: UIImage(named: "square.and.arrow.up.fill"),
                                            action: { _ in print("square") })
        let deleteAction = ContextMenuAction(title: "Delete",
                                             image: UIImage(named: "trash.fill"),
                                             tintColor: UIColor.red,
                                             action: { _ in print("delete") })
        let actions = [favoriteAction, shareAction, deleteAction]
        let contextMenu = ContextMenu(
            title: "Actions",
            actions: actions,
            delegate: self)
        contextMenuButtons
            .forEach {
                $0.addContextMenu(contextMenu, for: .tap(numberOfTaps: 1), .longPress(duration: 0.3))
            }
    }
}

extension ViewController: UIContextMenuInteractionDelegate {

    @available(iOS 13.0, *)
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {

        let favorite = UIAction(title: "Looooooooooooong title", image: UIImage(systemName: "heart.fill"), handler: { _ in })
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up.fill"), handler: { _ in })
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: [.destructive], handler: { _ in })

        let actions = [favorite, share, delete]

        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { _ in UIMenu(title: "Actions", children: actions) }
    }

}

extension ViewController: ContextMenuDelegate {

    func contextMenuWillAppear(_ contextMenu: ContextMenu) {
        print("context menu will appear")
    }
    
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("context menu did appear")
    }
}
