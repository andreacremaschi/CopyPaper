import Foundation
import UIKit
import ObjectiveC

var isTransparentAssociationKey: UInt8 = 0
extension UIView {
    
    @IBInspectable
    public var passThrough: Bool {
        get {
            return objc_getAssociatedObject(self, &isTransparentAssociationKey) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &isTransparentAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public override class func initialize() {
        guard self === UIView.self else { return }
        swizzleMethodSelector("hitTest:withEvent:", withSelector: "cp_hitTest:withEvent:", forClass: UIView.self)
    }

    private func cp_hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
//        print("\(self)")

        let hitView = self.cp_hitTest(point, withEvent: event)
        if hitView?.passThrough ?? false {
            guard let superview = self.superview else { return nil }
            guard let selfIndex = superview.subviews.indexOf(self) else { return nil }
            if (selfIndex > 0) {
                for i in (0...selfIndex-1).reverse() {
                    let nextViewInStack = superview.subviews[i];
                    let pointInView = nextViewInStack.convertPoint(point, fromView: self)
                    if let view = nextViewInStack.hitTest(pointInView, withEvent:event) {
                        return view
                    }
                }
            }
        }
        return hitView
    }
}