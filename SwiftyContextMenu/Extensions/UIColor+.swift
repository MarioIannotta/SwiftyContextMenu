extension UIColor {
    static var defaultLabelMenuActionColor: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
}
