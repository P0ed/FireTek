import SpriteKit
import Fx

struct CollisionsSystem {

	private let contactDelegate: SceneDelegate

	let didBeginContact: Stream<SKPhysicsContact>
	let didEndContact: Stream<SKPhysicsContact>

	init(scene: SKScene) {

		let (beginContactStream, beginContactPipe) = Stream<SKPhysicsContact>.pipe()
		didBeginContact = beginContactStream

		let (endContactStream, endContactPipe) = Stream<SKPhysicsContact>.pipe()
		didEndContact = endContactStream

		contactDelegate = SceneDelegate(didBeginContact: beginContactPipe, didEndContact: endContactPipe)
		scene.physicsWorld.contactDelegate = contactDelegate
	}

	@objc
	final class SceneDelegate: NSObject, SKPhysicsContactDelegate {

		private let _didBeginContact: (SKPhysicsContact) -> ()
		private let _didEndContact: (SKPhysicsContact) -> ()

		init(didBeginContact: (SKPhysicsContact) -> (), didEndContact: (SKPhysicsContact) -> ()) {
			_didBeginContact = didBeginContact
			_didEndContact = didEndContact
		}

		func didBeginContact(contact: SKPhysicsContact) {
			_didBeginContact(contact)
		}

		func didEndContact(contact: SKPhysicsContact) {
			_didEndContact(contact)
		}
	}
}
