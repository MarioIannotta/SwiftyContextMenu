//
//  ContextMenuViewController.swift
//  ContextMenu
//
//  Created by Mario Iannotta on 14/06/2020.
//

import UIKit

protocol ContextMenuViewControllerDelegate: class {

    func contextMenuViewControllerDidDismiss(_ contextMenuViewController: ContextMenuViewController)
}

class ContextMenuViewController: UIViewController {

    private var contextMenu: ContextMenu!
    private weak var delegate: ContextMenuViewControllerDelegate?

    private var blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var overlayView = UIView(frame: .zero)
    private var snapshotImageView = UIImageView(frame: .zero)
    private var contextMenuTableView = ContextMenuTableView()
    private var contextMenuView = UIView()

    private let cellIdentifier = "ContextMenuCell"

    private var isContextMenuUp: Bool { (contextMenu.sourceViewInfo?.targetFrame.midY ?? 0) > UIScreen.main.bounds.height / 2 }
    private var isContextMenuRight: Bool { (contextMenu.sourceViewInfo?.targetFrame.midX ?? 0) > UIScreen.main.bounds.width / 2 }

    init(contextMenu: ContextMenu, delegate: ContextMenuViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.contextMenu = contextMenu
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addBlurView()
        addBlackOverlay()
        addSnapshotView()
        addContextMenuTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeIn()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .clear
    }

    private func addBlurView() {
        blurView.alpha = 0
        view.fill(with: blurView)
    }

    private func addBlackOverlay() {
        overlayView.alpha = 0
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.fill(with: overlayView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissGestureRecognizer))
        overlayView.addGestureRecognizer(tapGesture)
    }

    private func addSnapshotView() {
        snapshotImageView.image = contextMenu.sourceViewInfo?.snapshot
        snapshotImageView.frame = contextMenu.sourceViewInfo?.originalFrame ?? .zero
        snapshotImageView.clipsToBounds = true
        snapshotImageView.layer.cornerRadius = contextMenu.layout.sourceViewCornerRadius
        view.addSubview(snapshotImageView)
    }

    private func addContextMenuTableView() {
        contextMenuTableView.delegate = self
        contextMenuTableView.dataSource = self
        contextMenuTableView.register(ContextMenuActionTableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        let arrangedSubviews = [makeTitleStackView(), contextMenuTableView].compactMap { $0 }
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 0
        blurView.contentView.fill(with: stackView)

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        blurView.layer.cornerRadius = 14
        blurView.clipsToBounds = true
        blurView.contentView.fill(with: stackView)

        contextMenuView.alpha = 0
        contextMenuView.layer.cornerRadius = 14
        contextMenuView.layer.borderWidth = 1
        contextMenuView.layer.borderColor = contextMenuTableView.separatorColor?.cgColor
        contextMenuView.layer.shadowColor = UIColor.black.cgColor
        contextMenuView.layer.shadowOffset = CGSize(width: 2, height: 5)
        contextMenuView.layer.shadowRadius = 6
        contextMenuView.layer.shadowOpacity = 0.08
        contextMenuView.translatesAutoresizingMaskIntoConstraints = false
        contextMenuView.fill(with: blurView)
        view.addSubview(contextMenuView)

        let edgeConstraint: NSLayoutConstraint
        let verticalConstraint: NSLayoutConstraint
        let horizontalConstraint: NSLayoutConstraint
        if isContextMenuUp {
            edgeConstraint = contextMenuView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor,
                                                                  constant: contextMenu.layout.padding)
            verticalConstraint = snapshotImageView.topAnchor.constraint(equalTo: contextMenuView.bottomAnchor,
                                                                        constant: contextMenu.layout.spacing)
        } else {
            edgeConstraint = bottomAnchor.constraint(greaterThanOrEqualTo: contextMenuView.bottomAnchor,
                                                     constant: contextMenu.layout.padding)
            verticalConstraint = contextMenuView.topAnchor.constraint(equalTo: snapshotImageView.bottomAnchor,
                                                                      constant: contextMenu.layout.spacing)
        }
        if isContextMenuRight {
            horizontalConstraint = snapshotImageView.trailingAnchor.constraint(equalTo: contextMenuView.trailingAnchor)
        } else {
            horizontalConstraint = contextMenuView.leadingAnchor.constraint(equalTo: snapshotImageView.leadingAnchor)
        }
        NSLayoutConstraint.activate([
            contextMenuView.widthAnchor.constraint(equalToConstant: 250),
            horizontalConstraint,
            verticalConstraint,
            edgeConstraint
        ])
    }

    private func makeTitleStackView() -> UIStackView? {
        guard
            let title = contextMenu.title
            else {
                return nil
            }
        let titleLabelContainterView = UIView(frame: .zero)
        titleLabelContainterView.backgroundColor = .clear
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = UIColor.gray
        titleLabel.textAlignment = .center
        titleLabelContainterView.fill(with: titleLabel, insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        let separatorView = UIView(frame: .zero)
        separatorView.backgroundColor = contextMenuTableView.separatorColor?.withAlphaComponent(0.15)
        NSLayoutConstraint.activate([separatorView.heightAnchor.constraint(equalToConstant: 1)])
        let stackView = UIStackView(arrangedSubviews: [titleLabelContainterView, separatorView])
        stackView.axis = .vertical
        return stackView
    }

    private func fadeIn() {
        contextMenu.delegate?.contextMenuWillAppear(contextMenu)
        contextMenuView.transform = contextMenu.optionsViewFirstTransform
        showSourceView {
            self.contextMenu.delegate?.contextMenuDidAppear(self.contextMenu)
            self.showContextMenu()
        }
    }

    private func showSourceView(completion: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.overlayView.alpha = 1
                self.blurView.alpha = 1
                self.snapshotImageView.transform = self.contextMenu.sourceViewFirstStepTransform
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        self.snapshotImageView.transform = self.contextMenu.sourceViewSecondTransform
                    },
                    completion: { _ in completion() })
                })
    }

    private func showContextMenu() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.contextMenuView.alpha = 1
                self.contextMenuView.transform = self.contextMenu.optionsViewSecondTransform

                let trasform = self.contextMenu.sourceViewThirdTransform(isContextMenuUp: self.isContextMenuUp,
                                                                         isContextMenuRight: self.isContextMenuRight)
                self.snapshotImageView.transform = trasform
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        self.contextMenuView.transform = self.contextMenu.optionsViewThirdTransform
                })
            })
    }

    private func fadeOutAndClose() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.blurView.alpha = 0
                self.contextMenuView.alpha = 0
                self.snapshotImageView.transform = .identity
                self.contextMenuView.transform = self.contextMenu.optionsViewFirstTransform
            },
            completion: { _ in
                self.delegate?.contextMenuViewControllerDidDismiss(self)
            })
    }

    @objc private func handleDismissGestureRecognizer() {
        fadeOutAndClose()
    }
}

extension ContextMenuViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contextMenu.actions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContextMenuActionTableViewCell
            else {
                return UITableViewCell()
            }
        cell.configure(action: contextMenu.actions[indexPath.row])
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = contextMenu.actions[indexPath.row]
        action.action?(action)
        fadeOutAndClose()
    }
}
