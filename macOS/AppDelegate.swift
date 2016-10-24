import Cocoa
import SpriteKit

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let scene = GameScene(fileNamed:"GameScene") {
            scene.scaleMode = .aspectFill

            self.skView!.presentScene(scene)

			self.skView!.ignoresSiblingOrder = true

            self.skView!.showsFPS = true
            self.skView!.showsNodeCount = true
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
