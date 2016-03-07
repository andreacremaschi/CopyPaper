import Foundation

internal extension NSObject {
    
    internal class func swizzleMethodSelector(originalSelectorName: String, withSelector swizzledSelectorName: String, forClass:AnyClass) {
        
        let originalSelector = Selector(stringLiteral: originalSelectorName)
        let swizzledSelector = Selector(stringLiteral: swizzledSelectorName)
        
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}