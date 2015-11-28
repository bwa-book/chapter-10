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

}

// MARK: Emoji list loading
extension InterfaceController {
    
}

// MARK: Emoji image loading
extension InterfaceController {
    
}
