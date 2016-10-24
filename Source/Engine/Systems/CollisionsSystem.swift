import SpriteKit
import Fx

struct CollisionsSystem {

	private let contactDelegate: SceneDelegate

	let didBeginContact: Signal<SKPhysicsContact>
	let didEndContact: Signal<SKPhysicsContact>

	init(scene: SKScene) {

		let (beginContactStream, beginContactPipe) = Signal<SKPhysicsContact>.pipe()
		didBeginContact = beginContactStream

		let (endContactStream, endContactPipe) = Signal<SKPhysicsContact>.pipe()
		didEndContact = endContactStream

		contactDelegate = SceneDelegate(didBeginContact: beginContactPipe, didEndContact: endContactPipe)
		scene.physicsWorld.contactDelegate = contactDelegate
	}

	@objc
	final class SceneDelegate: NSObject, SKPhysicsContactDelegate {

		private let didBeginContact: (SKPhysicsContact) -> ()
		private let didEndContact: (SKPhysicsContact) -> ()

		init(didBeginContact: @escaping (SKPhysicsContact) -> (), didEndContact: @escaping (SKPhysicsContact) -> ()) {
			self.didBeginContact = didBeginContact
			self.didEndContact = didEndContact
		}

		func didBegin(_ contact: SKPhysicsContact) {
			didBeginContact(contact)
		}

		func didEnd(_ contact: SKPhysicsContact) {
			didEndContact(contact)
		}
	}
}
