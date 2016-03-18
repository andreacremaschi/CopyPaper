import Foundation
import UIKit
import ObjectiveC

var isTransparentAssociationKey: UInt8 = 0
extension UIView {
    
    @IBInspectable
    public var passThrough: Bool {
        get {
            print ("\(String(self.dynamicType))")
            if (String(self.dynamicType) == "UIViewControllerWrapperView" ||
                String(self.dynamicType) == "UINavigationTransitionView") { return true }
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

    public func cp_hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {

        guard let hitView = self.cp_hitTest(point, withEvent: event) else { return nil }

        // If the gesture shouldn't pass through, return the hit view
        guard hitView.passThrough else { return hitView }

        // If the gesture should pass through but there is no super view, return nil
        guard let underneathSiblingView = self.underneathSiblingView() else {

            // If the gesture should pass through but there are no siblings views underneath
            // hit test the underneath sibling view of the superview
            guard let superview = self.superview else { return nil }
            guard superview.passThrough else { return superview }
            guard let superUnderneathSiblingView = superview.underneathSiblingView() else { return nil }
            let pointInView = superUnderneathSiblingView.convertPoint(point, fromView: self)
            return superUnderneathSiblingView.hitTest(pointInView, withEvent: event)
        }
        
        // Test the underneath sibling for hit
        let pointInView = underneathSiblingView.convertPoint(point, fromView: self)
        return underneathSiblingView.hitTest(pointInView, withEvent:event)
    }
    
    private func underneathSiblingView() -> UIView? {
        guard let superview = self.superview else { return nil }
        let selfIndex = superview.subviews.indexOf(self)!
        guard selfIndex > 0 else { return nil }
        return superview.subviews[selfIndex - 1]
    }
}