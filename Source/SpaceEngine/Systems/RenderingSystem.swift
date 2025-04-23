import SpriteKit

final class RenderingSystem {
	private let world: World
	private let ref: WeakRef<Physics>?
	private var disposable = [] as [Any]

	init(world: World, player: Entity, scene: SKScene) {
		self.world = world
		ref = world.physics.weakRefOf(player)

		world.physics.forEach { scene.addChild($0.node) }
		disposable = [
			world.physics.newComponents.observe { [unowned scene] index in
				scene.addChild(world.physics[index].node)
			},
			world.physics.removedComponents.observe { _, c in
				c.node.removeFromParent()
			}
		]
	}

	func update() {
		let maxR = 192 as CGFloat
		let position = ref?.value?.position ?? .zero
		let rotation = ref?.value?.rotation ?? 0
		world.physics.forEach { physics in
			let v = (physics.position - position).vector
			let len = v.length

			func f(_ r: CGFloat) -> CGFloat {
				max(0, min(maxR, r)) - maxR / max(1, r / maxR) + maxR
			}

			let scaled: CGVector = v == .zero ? .zero : v.normalized.rotate(-rotation) * f(len)
			physics.node.position = scaled.point

			let scale: CGFloat = len > maxR ? maxR / len : 1
			physics.node.setScale(scale)
			physics.node.zRotation = physics.rotation - rotation
		}
	}
}
