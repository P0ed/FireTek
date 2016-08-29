import SpriteKit
import PowerCore

struct CameraSystem {

	let player: Closure<SpriteComponent>.Getter
	let camera: SKCameraNode

	func update() {
		camera.position = player().sprite.position
	}
}