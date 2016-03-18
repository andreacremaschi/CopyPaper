[![Version](https://img.shields.io/cocoapods/v/CopyPaper.svg?style=flat)](http://cocoapods.org/pods/CopyPaper)
[![License](https://img.shields.io/cocoapods/l/CopyPaper.svg?style=flat)](http://cocoapods.org/pods/CopyPaper)
[![Platform](https://img.shields.io/cocoapods/p/CopyPaper.svg?style=flat)](http://cocoapods.org/pods/CopyPaper)

CopyPaper
========

_Let gestures pass through views, so that you can overlay view controllers_

`CopyPaper` is a twist over the standard `UIKit` behavior. 
Let's say we want to build an app that keeps a map or a collection view (A) in the background and a navigation controller (B) over it, like in the following example:



`UIKit` wouldn't allow you to have gestures be transmitted through the views' hierarchy to the one underneath, i.e. to pan the map or to tap on items on the collection's view. `CopyPaper` let you just do that.

Usage
============

The most straightforward way to use `CopyPaper` is to call `self.overlayViewController(viewController)` passing the overlaying viewcontroller as an argument in the `viewDidLoad` function of the underlying viewcontroller (take a look at the example). The framework will take care of everything: making the overlying viewcontroller transparent and able to pass gestures underneath.


How it works
============

`CopyPaper` swizzles `hitTest(point: CGPoint, withEvent event: UIEvent?)` to hijack the way UIKit handles the gesture handling chain.  
In addition, `CopyPaper` adds one associated property to all `UIView`s and one to `UIViewController`s:
 
This is the property added to `UIView`s, a flag that tells the view if it should pass the gesture through to the underlaying one or not:

```swift
    @IBInspectable public var passThrough: Bool
```

This is the property added to `UIViewController`s, to be set before it is loaded, that tells the viewcontroller if it should be transparent and if its main view should have the `passThrough` property enabled or not:

```swift
    @IBInspectable public var overlay: Bool 
```

### Isn't `userInteractionEnabled` enough for that?

No. This is what Apple Documentation says about UIView's `userInteractionEnabled` property:

```When set to false, user events—such as touch and keyboard—intended for the view are ignored and removed from the event queue. When set to true, events are delivered to the view normally.```

The problem is that:

- when `userInteractionEnabled` is set to `true` for a view, if none of the subviews can handle the gesture, that view will do it.
- when `userInteractionEnabled` is set to `false` for a view, none of the subviews neither the view can handle the gesture.

This doesn't work if you want a container view to pass the gesture to its subviews and, if none of them can handle the gesture, pass it through the underneath view.

Installation
============

CopyPaper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CopyPaper', '~> 0.1.0'
```

Author
======
**Andrea Cremaschi**

* <https://twitter.com/andreacremaschi>
* <https://linkedin.com/in/acremaschi>
* <https://github.com/andreacremaschi>

License
=======

CopyPaper is available under the MIT license. See the LICENSE file for more info.