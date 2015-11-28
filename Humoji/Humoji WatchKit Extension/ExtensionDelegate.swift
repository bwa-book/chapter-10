import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    var communicationManager: CommunicationManager?
    
    func applicationDidFinishLaunching() {
        communicationManager = CommunicationManager.sharedInstance
    }

}
