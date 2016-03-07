import Foundation
import UIKit

var isOverlaidAssociationKey: UInt8 = 0
extension UIViewController {
    
    override public class func initialize() {
        guard self === UIViewController.self else { return }
        swizzleMethodSelector("viewDidLoad", withSelector: "cp_viewDidLoad", forClass: self)
    }
    
    func cp_viewDidLoad() {
        cp_viewDidLoad()
        if self.overlay || (self.parentViewController?.overlay ?? false) {
            view.passThrough = true
            view.backgroundColor = UIColor.clearColor()
        }
    }
    
    @IBInspectable
    public var overlay: Bool {
        get {
            return objc_getAssociatedObject(self, &isOverlaidAssociationKey) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &isOverlaidAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func overlayViewController(viewController: UIViewController) {
        self.addChildViewController(viewController)
        viewController.overlay = true
        viewController.view.frame = self.view.frame
        self.view.addSubview(viewController.view)
    }
}