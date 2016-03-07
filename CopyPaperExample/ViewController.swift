import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navVC = self.storyboard?.instantiateViewControllerWithIdentifier("overlappingVC") as? UINavigationController {
            self.overlayViewController(navVC)

            // Make the Navigation bar transparent, just for fun
            let navigationBar = navVC.navigationBar
            navigationBar.backgroundColor = UIColor.clearColor()
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            navigationBar.shadowImage = UIImage()
            navigationBar.translucent = true
            navigationBar.tintColor = UIColor.blackColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class FirstViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewDidDisappear(animated)
    }
}

class BetterSegue: UIStoryboardSegue {
    
    override func perform() {
     
        let transition = CATransition()
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFade;

        if let navigationController = sourceViewController.navigationController {
        navigationController.view.layer.addAnimation(transition, forKey: kCATransition)
        navigationController.pushViewController(destinationViewController, animated: false)
        }

    }
}