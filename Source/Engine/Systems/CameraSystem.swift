import SpriteKit
import PowerCore

struct CameraSystem {

	let player: SKSpriteNode
	let camera: SKCameraNode

	func update() {
		camera.position = player.position
	}
}