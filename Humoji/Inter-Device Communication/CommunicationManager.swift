import Foundation
import WatchConnectivity

class CommunicationManager: NSObject {
    
    static let sharedInstance = CommunicationManager()
    private override init() {
        super.init()
        setupSession()
    }
    
    var session: WCSession?
    
    var onReceivedMessageData: (NSData -> Void)?
    
    func sendMessageData(data: NSData) {
        if let session = session where session.reachable {
            session.sendMessageData(data, replyHandler: nil, errorHandler: nil)
        }
    }
    
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
    
    func session(session: WCSession, didReceiveMessageData messageData: NSData) {
        onReceivedMessageData?(messageData)
    }
    
}
