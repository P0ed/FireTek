import SpriteKit

final class RenderingSystem {
	let camera: SKCameraNode
	let world: World
	let ref: WeakRef<PhysicsComponent>?

	init(world: World, camera: SKCameraNode, ref: WeakRef<PhysicsComponent>?) {
		self.world = world
		self.camera = camera
		self.ref = ref
	}

	func update() {
//		let position = ref?.value?.position ?? .zero
		world.physics.forEach { physics in
			physics.node.position = physics.position
			physics.node.zRotation = physics.rotation.radians
		}
	}
}
