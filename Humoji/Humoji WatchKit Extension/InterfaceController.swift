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

}

// MARK: Emoji list loading
extension InterfaceController {
    
}

// MARK: Emoji image loading
extension InterfaceController {
    
}
