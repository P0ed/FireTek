import Fx
import SpriteKit

final class HUDSystem {
	private let world: World
	private let hudNode: HUDNode

	private var playerSprite: WeakRef<SpriteComponent>?
	private var playerPhysics: WeakRef<PhysicsComponent>?

	private var playerTarget: WeakRef<TargetComponent>?
	private var targetStats: WeakRef<Ship>?
	private var playerStats: WeakRef<Ship>?

	private let disposable = SerialDisposable()

	init(world: World, player: Entity, hudNode: HUDNode) {
		self.world = world
		self.hudNode = hudNode

		playerSprite = world.sprites.weakRefOf(player)
		playerPhysics = world.physics.weakRefOf(player)
		playerTarget = world.targets.weakRefOf(player)
		playerStats = world.ships.weakRefOf(player)
	}

	func update() {
		fillHud()

		let stats = playerStats?.value
		updateHPNode(node: hudNode.playerHP, hp: stats?.hp)
		updateHPNode(node: hudNode.targetHP, hp: targetStats?.value?.hp)

		updateBar(node: hudNode.weapon1, progress: stats?.primary.capacitor.normalized ?? 1)
		updateBar(node: hudNode.weapon2, progress: stats?.secondary.capacitor.normalized ?? 1)
		updateBar(node: hudNode.capacitor, progress: stats?.reactor.normalized ?? 1)
		updateBar(node: hudNode.shield, progress: stats?.shield.normalized ?? 1)

		if let physics = playerPhysics?.value {
			let x = Int(physics.position.x)
			let y = Int(physics.position.y)
			let dx = Int(physics.momentum.dx * 60)
			let dy = Int(physics.momentum.dy * 60)

			hudNode.playerHP.label.text = "x: \(x), y: \(y), dx: \(dx), dy: \(dy) \(physics.rotation.radians)"
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

	private func updateHPNode(node: HPNode, hp: HP?) {
		if let hp = hp {
			node.alpha = 0.8
			node.hpCell.colorBlendFactor = 1 - CGFloat(hp.core) / CGFloat(hp.maxStructure)

			(0..<40).forEach { idx in
				node.armorCells[idx].colorBlendFactor = 1 - CGFloat(min(hp.front, hp.side)) / CGFloat(hp.maxArmor)
			}
		} else {
			node.alpha = 0
		}
	}

	private func updateBar(node: BarNode, progress: CGFloat) {
		node.progress.size.width = BarNode.size.width * progress
	}
}
