import SpriteKit

final class RenderingSystem {
	let world: World
	let ref: WeakRef<PhysicsComponent>?

	init(world: World, ref: WeakRef<PhysicsComponent>?) {
		self.world = world
		self.ref = ref
	}

	func update() {
		let maxR = 160 as CGFloat
		let position = ref?.value?.position ?? .zero
		world.physics.forEach { physics in
			let v = (physics.position - position).vector
			let len = v.length

			func f(_ r: CGFloat) -> CGFloat {
				max(0, min(maxR, r)) - maxR / max(1, r / maxR) + maxR
			}

			let scaled: CGVector = v == .zero ? .zero : v.normalized() * f(len)
			physics.node.position = scaled.point

			let scale: CGFloat = len > maxR ? maxR / len : 1
			physics.node.setScale(scale)
			physics.node.zRotation = physics.rotation.radians
		}
	}
}
