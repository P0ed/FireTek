import PowerCore
import Fx
import Runes

final class HUDSystem {

	private let world: World
	private let hudNode: HUDNode

	private var targetLifetime: UInt16 = 0
	private var playerHP: Component<HPComponent>?
	private var targetHP: Component<HPComponent>?

	init(world: World, player: Entity, hudNode: HUDNode) {
		self.world = world
		self.hudNode = hudNode

		if let playerIndex = world.hp.indexOf(player) {
			playerHP = world.hp.instanceAt(playerIndex)
		}
	}

	func update() {
		fillHud()
		updateNode()
	}

	private func fillHud() {
		if targetHP != nil && targetLifetime > 0 {
			targetLifetime -= 1
		}
		if targetLifetime == 0 { targetHP = nil }
	}

	private func updateNode() {
		if let hp = playerHP?.value {
			hudNode.playerArmor.alpha = 0.9
			hudNode.playerArmor.hpCell.colorBlendFactor = 1 - CGFloat(hp.currentHP) / CGFloat(hp.maxHP)

			for (index, armor) in hp.structure.enumerated() {
				hudNode.playerArmor.armorCells[index].colorBlendFactor = 1 - CGFloat(armor) / CGFloat(UInt8.max)
			}
		} else {
			hudNode.playerArmor.alpha = 0
		}
	}
}
