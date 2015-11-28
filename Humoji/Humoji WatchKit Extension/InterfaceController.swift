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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if pickerItems.isEmpty {
            pickerItems = [loadingPickerItem()]
            requestData()
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
    
}

// MARK: Emoji image loading
extension InterfaceController {
    
}
