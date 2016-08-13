import Cocoa
import SpriteKit

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let scene = GameScene(fileNamed:"GameScene") {
            scene.scaleMode = .AspectFill

            self.skView!.presentScene(scene)

			self.skView!.ignoresSiblingOrder = true

            self.skView!.showsFPS = true
            self.skView!.showsNodeCount = true
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
