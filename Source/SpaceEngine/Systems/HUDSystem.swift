import Fx
import SpriteKit

final class HUDSystem {
	private let world: World
	private let hudNode: HUDNode

	private var playerPhysics: WeakRef<PhysicsComponent>?

	private var playerTarget: WeakRef<TargetComponent>?
	private var targetStats: WeakRef<Ship>?
	private var playerStats: WeakRef<Ship>?

	private let disposable = SerialDisposable()

	init(world: World, player: Entity, hudNode: HUDNode) {
		self.world = world
		self.hudNode = hudNode

		playerPhysics = world.physics.weakRefOf(player)
		playerTarget = world.targets.weakRefOf(player)
		playerStats = world.ships.weakRefOf(player)
	}

	func update() {
		fillHud()

		let stats = playerStats?.value
		updateBar(node: hudNode.front, progress: stats.map { CGFloat($0.hp.front) / CGFloat($0.hp.maxArmor) })
		updateBar(node: hudNode.side, progress: stats.map { CGFloat($0.hp.side) / CGFloat($0.hp.maxArmor) })
		updateBar(node: hudNode.core, progress: stats.map { CGFloat($0.hp.core) / CGFloat($0.hp.maxStructure) })
		updateBar(node: hudNode.shield, progress: stats?.shield.normalized ?? 1)
		updateBar(node: hudNode.targetFront, progress: targetStats?.value.map { CGFloat($0.hp.front) / CGFloat($0.hp.maxArmor) })
		updateBar(node: hudNode.targetSide, progress: targetStats?.value.map { CGFloat($0.hp.side) / CGFloat($0.hp.maxArmor) })
		updateBar(node: hudNode.targetCore, progress: targetStats?.value.map { CGFloat($0.hp.core) / CGFloat($0.hp.maxStructure) })
		updateBar(node: hudNode.targetShield, progress: targetStats?.value?.shield.normalized)

		updateBar(node: hudNode.weapon1, progress: stats?.primary.capacitor.normalized ?? 1)
		updateBar(node: hudNode.weapon2, progress: stats?.secondary.capacitor.normalized ?? 1)
		updateBar(node: hudNode.capacitor, progress: stats?.reactor.normalized ?? 1)

		if let physics = playerPhysics?.value {
			let x = Int(physics.position.x)
			let y = Int(physics.position.y)
			let dx = Int(physics.momentum.dx * 60)
			let dy = Int(physics.momentum.dy * 60)

			updateBar(node: hudNode.impulse, progress: min(1, physics.momentum.length / 3.3))

			hudNode.message.text = "x: \(x), y: \(y)\ndx: \(dx), dy: \(dy)\na: \(physics.rotation)"
		}
	}

	private func fillHud() {
		if let target = playerTarget?.value?.target {
			if targetStats?.entity != target {
				targetStats = world.ships.weakRefOf(target)
			}
		} else {
			targetStats = nil
		}
	}

	private func updateBar(node: BarNode, progress: CGFloat?) {
		if let progress {
			node.progress.size.width = BarNode.size.width * progress
			node.alpha = 1
		} else {
			node.alpha = 0
		}
	}
}
