import SpriteKit

final class RenderingSystem {
	let camera: SKCameraNode
	let world: World
	let ref: WeakRef<PhysicsComponent>?

	init(world: World, camera: SKCameraNode, ref: WeakRef<PhysicsComponent>?) {
		self.world = world
		self.camera = camera
		self.ref = ref
		camera.position = .zero
	}

	func update() {
		let maxR = 640 as CGFloat
		let position = ref?.value?.position ?? .zero
		world.physics.forEach { physics in
			let v = (physics.position - position).vector
			let len = v.length
			let s = len > maxR / 2 ? maxR / 2 / len : 1

			func f(_ r: CGFloat) -> CGFloat {
				max(0, min(maxR / 2, r)) - maxR / 6 / (max(1, r / maxR / 2)) + maxR / 6
			}

			if v == .zero {
				physics.node.position = .zero
			} else {
				let vscale = f(len)
				let scaled = v.normalized() * vscale / 2
				physics.node.position = scaled.point
			}

			physics.node.setScale(s)
			physics.node.zRotation = physics.rotation.radians
		}
	}
}
