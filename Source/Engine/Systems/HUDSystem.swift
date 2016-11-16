import PowerCore
import Fx
import Runes

final class HUDSystem {

	private let world: World
	private let hudNode: HUDNode

	private var playerHP: Component<HPComponent>?
	private var playerTarget: Component<TargetComponent>?
	private var targetHP: Component<HPComponent>?

	init(world: World, player: Entity, hudNode: HUDNode) {
		self.world = world
		self.hudNode = hudNode

		playerHP = world.hp.instanceAt <^> world.hp.indexOf(player)
		playerTarget = world.targets.instanceAt <^> world.targets.indexOf(player)
	}

	func update() {
		fillHud()

		updateNode(node: hudNode.playerHP, hp: playerHP?.value)
		updateNode(node: hudNode.targetHP, hp: targetHP?.value)
	}

	private func fillHud() {
		if let target = playerTarget?.value?.target {
			if targetHP?.entity != target {
				targetHP = world.hp.instanceAt <^> world.hp.indexOf(target)
			}
		} else {
			targetHP = nil
		}
	}

	private func updateNode(node: HPNode, hp: HPComponent?) {
		if let hp = hp {
			node.alpha = 0.9
			node.hpCell.colorBlendFactor = 1 - CGFloat(hp.currentHP) / CGFloat(hp.maxHP)

			for (index, armor) in hp.structure.enumerated() {
				node.armorCells[index].colorBlendFactor = 1 - CGFloat(armor) / CGFloat(UInt8.max)
				node.armorCells[index].alpha = hp.armor == 0 ? 0.2 : 1
			}
		} else {
			node.alpha = 0
		}
	}
}
