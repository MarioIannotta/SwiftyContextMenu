//
//  ContextMenuTitleLabel.swift
//  SwiftyContextMenu
//
//  Created by Paul Bancarel on 28/11/2020.
//

class IntensityVisualEffectView: UIVisualEffectView {

    private var animator: UIViewPropertyAnimator!
    private let intensity: CGFloat
    private let _effect: UIVisualEffect
    
    init(effect: UIVisualEffect, intensity: CGFloat) {
        self.intensity = intensity
        self._effect = effect
        super.init(effect: nil)
        apply(intensity: intensity)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func applicationWillEnterForeground() {
        effect = nil
        apply(intensity: intensity)
    }
    
    private func apply(intensity: CGFloat) {
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = _effect }
        animator.fractionComplete = intensity
    }
    
}
