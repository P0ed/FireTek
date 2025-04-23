import Fx
import SpriteKit

final class HUDSystem {
	private let world: World
	private let hudNode: HUDNode

	private var playerShipRef: WeakRef<ShipRef>?
	private var playerPhysics: WeakRef<Physics>?
	private var playerStats: WeakRef<Ship>?
	private var targetStats: WeakRef<Ship>?
	private var message: String = ""

	private let disposable = SerialDisposable()

	init(world: World, player: Entity, hudNode: HUDNode) {
		self.world = world
		self.hudNode = hudNode

		playerShipRef = world.shipRefs.weakRefOf(player)
		playerPhysics = world.physics.weakRefOf(player)
		playerStats = world.ships.weakRefOf(player)
	}

	func update(message: String) {
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

		updateBar(node: hudNode.weapon1, progress: stats?.primary.capacitor.normalized)
		updateBar(node: hudNode.weapon2, progress: stats?.secondary.capacitor.normalized)
		updateBar(node: hudNode.capacitor, progress: stats?.reactor.normalized)

		if message != self.message {
			self.message = message
			hudNode.message.attributedText = text(message)
		}
	}

	private func fillHud() {
		if let target = playerShipRef?.value?.target {
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

func text(_ string: String) -> NSAttributedString {
	let ps = NSMutableParagraphStyle()
	ps.alignment = .right
	let c = SKColor.white
	let f = NSFont(name: "Menlo", size: 10)!
	return .init(string: string, attributes: [.paragraphStyle: ps, .foregroundColor: c, .font: f])
}
