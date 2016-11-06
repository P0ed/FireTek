import PowerCore
import Fx
import Runes

final class HUDSystem {

	private let world: World
	private let hudNode: HUDNode

	private var player: Entity?
	private var target: Entity?
	private var targetLifetime: UInt16 = 0
	private var playerHP: HPComponent?
	private var targetHP: HPComponent?

	init(world: World, player: Entity, hudNode: HUDNode) {
		self.world = world
		self.player = player
		self.hudNode = hudNode
	}

	func update() {
		fillHud()
		updateNode()
	}

	private func fillHud() {
		if target != nil && targetLifetime > 0 {
			targetLifetime -= 1
		}
		if targetLifetime == 0 { target = nil }

		playerHP = world.hp.instanceOf -<< player
		targetHP = world.hp.instanceOf -<< target
	}

	private func updateNode() {
		if let hp = playerHP {
			hudNode.playerArmor.alpha = 1
			hudNode.playerArmor.hpCell.alpha = CGFloat(hp.currentHP) / CGFloat(hp.maxHP)
			for (index, armor) in hp.structure.enumerated() {
				hudNode.playerArmor.armorCells[index].alpha = CGFloat(armor) / CGFloat(UInt8.max)
			}
		} else {
			hudNode.playerArmor.alpha = 0
		}
	}
}
