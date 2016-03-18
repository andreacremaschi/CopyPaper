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
        return hitView.cp_passThroughTest(point, withEvent: event)
    }
    
    private func cp_passThroughTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {

        // If the gesture shouldn't pass through, return self
        guard self.passThrough else { return self }
        
        // If the gesture should pass through but there are no siblings views underneath
        // search for the first underneath sibling view in the superviews hierarchy
        guard let underneathSiblingView = self.underneathSiblingView() else {
            
            guard let superview = self.superview else {
                // No underneath sibling, no superview: someone set passThrough = true to the main UIWindow!
                return nil
            }
            let pointInSuperview = superview.convertPoint(point, fromView: self)
            return superview.cp_passThroughTest(pointInSuperview, withEvent: event)
        }
        
        // Test the underneath sibling view for hit
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