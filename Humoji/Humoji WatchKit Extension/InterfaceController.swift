import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var image: WKInterfaceImage!
    @IBOutlet var picker: WKInterfacePicker!
    
    private var pickerIndex = 0
    private var imageLoadTimer: NSTimer?
    private var emojiList: [(String, String)] = []
    
    private var pickerItems: [WKPickerItem] = [] {
        didSet {
            picker.setItems(pickerItems)
            picker.focus()
        }
    }
    
    private var emojiListDataTask: NSURLSessionDataTask?
    
    @IBAction func emojiSelected(value: Int) {
        pickerIndex = value
        
        imageLoadTimer?.invalidate()
        imageLoadTimer = NSTimer(
            timeInterval: 0.3,
            target: self,
            selector: "imageTimerFired:",
            userInfo: nil,
            repeats: false
        )
        NSRunLoop.mainRunLoop().addTimer(imageLoadTimer!, forMode: NSDefaultRunLoopMode)
    }
    
    func imageTimerFired(timer: NSTimer) {
        timer.invalidate()
        loadImageFromAddress(emojiList[pickerIndex].1)
    }
    
    private var communicationManager: CommunicationManager?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if pickerItems.isEmpty {
            pickerItems = [loadingPickerItem()]
            requestData()
        }
        
        if let extensionDelegate = WKExtension.sharedExtension().delegate as? ExtensionDelegate {
            communicationManager = extensionDelegate.communicationManager
        }
    }
    
    private func loadingPickerItem() -> WKPickerItem {
        let item = WKPickerItem()
        item.title = "Loading..."
        
        return item
    }
    
    private func pickerItems(emoji: [(String, String)]) -> [WKPickerItem] {
        return emoji.map { (name, _) in
            let item = WKPickerItem()
            item.title = name
            return item
        }
    }

}

// MARK: Emoji list loading
extension InterfaceController {
    
    private func processData(data: NSData?, error: NSError?) {
        guard let data = data else {
            if let error = error {
                print(error.description)
            }
            return
        }
        
        do {
            if let receivedEmojiList = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String:String] {
                emojiList = receivedEmojiList.map { name, address in (name, address) }
                picker.setItems(pickerItems(emojiList))
                loadImageFromAddress(emojiList[0].1)
            }
        }
        catch {
            print("Error decoding emoji list")
        }
    }
    
    private func requestData() {
        guard emojiListDataTask?.state != .Running else {return}
        
        let semaphore = dispatch_semaphore_create(0)
        beginBackgroundTask(semaphore)
        
        let url = NSURL.init(string: "https://api.github.com/emojis")!
        let urlSession = NSURLSession.sharedSession()
        emojiListDataTask = urlSession.dataTaskWithURL(url) { data, response, error in
            self.processData(data, error: error)
            self.endBackgroundTask(semaphore)
        }
        
        emojiListDataTask?.resume()
    }
    
    private func beginBackgroundTask(semaphore: dispatch_semaphore_t) {
        NSProcessInfo.processInfo().performExpiringActivityWithReason("emojiListRequest") { expired in
            if !expired {
                let fifteenSecondsFromNow = dispatch_time(DISPATCH_TIME_NOW, Int64(15 * NSEC_PER_SEC))
                dispatch_semaphore_wait(semaphore, fifteenSecondsFromNow)
            } else {
                print("No more background activity permitted")
                self.endBackgroundTask(semaphore)
            }
        }
    }
    
    private func endBackgroundTask(semaphore: dispatch_semaphore_t) {
        dispatch_semaphore_signal(semaphore)
    }
    
}

// MARK: Emoji image loading
extension InterfaceController {
    
    private func loadImageFromAddress(address: String?) {
        guard let address = address else {
            image.setImage(nil)
            return
        }
        
        let url = NSURL.init(string: address)!
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.downloadTaskWithURL(url) { tempFileUrl, response, error in
            if let tempFileUrl = tempFileUrl,
                   imageData = NSData.init(contentsOfURL: tempFileUrl),
                   downloadedImage = UIImage.init(data: imageData) {
                self.image.setImage(downloadedImage)
                    self.communicationManager?.sendMessageData(imageData)
            } else {
                self.image.setImage(nil)
            }
        }
        
        task.resume()
    }
    
}
