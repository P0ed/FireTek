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
		skView.showsNodeCount = true
//		skView.showsFields = true

		router = Router(view: skView)

		let state = GameState.create()
		let controller = GameController(state: state)
		router.push(controller)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
