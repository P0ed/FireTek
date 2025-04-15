import Cocoa
import SpriteKit

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
	var router: Router!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
		skView.ignoresSiblingOrder = true
		skView.showsFPS = true

		router = Router(view: skView)
		router.startNewGame()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}
