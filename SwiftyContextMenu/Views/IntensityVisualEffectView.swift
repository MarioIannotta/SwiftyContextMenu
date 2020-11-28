class IntensityVisualEffectView: UIVisualEffectView {

    private var animator: UIViewPropertyAnimator!
    private let intensity: CGFloat
    private let visualEffect: UIVisualEffect
    
    init(effect: UIVisualEffect, intensity: CGFloat) {
        self.intensity = intensity
        self.visualEffect = effect
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
        animator.fractionComplete = intensity
        
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
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = visualEffect }
        animator.fractionComplete = intensity
    }
    
}
