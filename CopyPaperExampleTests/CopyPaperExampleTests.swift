import XCTest
@testable import CopyPaperExample

class CopyPaperExampleTests: XCTestCase {
    
    func testCopyPaper() {

        // Create a viewcontroller
        let vc1 = UIViewController()
        let hitView1 = vc1.view.hitTest(CGPoint.zero, withEvent: UIEvent())
        XCTAssert(vc1.view === hitView1)
        
        // Overlay a viewcontroller on top of the first one
        let vc2 = UIViewController()
        vc1.overlayViewController(vc2)
        XCTAssert(vc2.view.superview === vc1.view)
        XCTAssert(vc2.view.backgroundColor == UIColor.clearColor())
        
        // Check that the gestures received from the top vc are passed underneath
        let hitView2 = vc2.view.hitTest(CGPoint.zero, withEvent: UIEvent())
        XCTAssert(hitView2 === vc1.view)
        
        // Insert a non-passthrough view below the view2 and check that it receives gestures
        let view3 = UIView(frame: vc2.view.frame)
        vc1.view.insertSubview(view3, belowSubview: vc2.view)
        let hitView3 = vc2.view.hitTest(CGPoint.zero, withEvent: UIEvent())
        XCTAssert(hitView3 === view3)

        // Make it passthrough and check if the vc1.view receives the gestures
        view3.passThrough = true
        let hitView4 = vc2.view.hitTest(CGPoint.zero, withEvent: UIEvent())
        XCTAssert(hitView4 === vc1.view)

    }
    
}
