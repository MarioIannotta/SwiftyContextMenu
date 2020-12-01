//
//  ContextMenuTitleLabel.swift
//  SwiftyContextMenu
//
//  Created by Paul Bancarel on 28/11/2020.
//

class SeparatorView: UIView {
    
    override class var layerClass: AnyClass { return CAShapeLayer.self }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayer()
    }
    
    private func updateLayer() {
        let layer = self.layer as! CAShapeLayer
        layer.path = UIBezierPath(rect: bounds).cgPath
        layer.fillColor = tintColor.cgColor
    }
}
