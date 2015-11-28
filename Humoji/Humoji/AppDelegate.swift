import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        if let rootViewController = window?.rootViewController as? ViewController {
            rootViewController.communicationManager = CommunicationManager.sharedInstance
        }
        
        return true
    }

}

