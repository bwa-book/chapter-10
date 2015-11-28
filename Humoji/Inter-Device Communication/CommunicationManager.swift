import Foundation
import WatchConnectivity

class CommunicationManager: NSObject {
    
    static let sharedInstance = CommunicationManager()
    private override init() {
        super.init()
        setupSession()
    }
    
    var session: WCSession?
    
}

extension CommunicationManager: WCSessionDelegate {
    
    private func setupSession() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        } else {
            print("WCSession unsupported")
        }
    }
    
}
