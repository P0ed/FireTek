import SpriteKit
import PowerCore

struct CameraSystem {

	let player: SKSpriteNode
	let camera: SKCameraNode

	func update() {
//		camera.run(SKAction.move(to: player.position, duration: 0.2))
		camera.position = player.position
	}
}
