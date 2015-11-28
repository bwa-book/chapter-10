import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    internal var communicationManager: CommunicationManager? {
        didSet {
            communicationManager?.onReceivedMessageData = { data in
                self.dataReceived(data)
            }
        }
    }
    
    private func dataReceived(data: NSData) {
        dispatch_async(dispatch_get_main_queue()) {
            if let image = UIImage(data: data) {
                self.imageView.image = image
            }
        }
    }

}

