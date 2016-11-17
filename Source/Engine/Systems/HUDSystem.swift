import PowerCore
import Fx
import Runes

final class HUDSystem {

	private let world: World
	private let hudNode: HUDNode

	private var playerHP: Component<HPComponent>?
	private var playerTarget: Component<TargetComponent>?
	private var targetHP: Component<HPComponent>?

	private var primaryWeapon: Component<WeaponComponent>?
	private var secondaryWeapon: Component<WeaponComponent>?

	init(world: World, player: Entity, hudNode: HUDNode) {
		self.world = world
		self.hudNode = hudNode

		playerHP = world.hp.instanceAt <^> world.hp.indexOf(player)
		playerTarget = world.targets.instanceAt <^> world.targets.indexOf(player)
		primaryWeapon = world.primaryWpn.instanceAt <^> world.primaryWpn.indexOf(player)
		secondaryWeapon = world.secondaryWpn.instanceAt <^> world.primaryWpn.indexOf(player)
	}

	func update() {
		fillHud()

		updateHPNode(node: hudNode.playerHP, hp: playerHP?.value)
		updateHPNode(node: hudNode.targetHP, hp: targetHP?.value)

		updateWeaponNode(node: hudNode.weapon1, weapon: primaryWeapon?.value)
		updateWeaponNode(node: hudNode.weapon2, weapon: secondaryWeapon?.value)
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

	private func updateHPNode(node: HPNode, hp: HPComponent?) {
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

	private func updateWeaponNode(node: WeaponNode, weapon: WeaponComponent?) {
		if let weapon = weapon {
			node.alpha = 1

			node.roundsLabel.text = "\(weapon.ammo)"

			if weapon.remainingCooldown > 0 || weapon.ammo == 0 {
				if weapon.rounds == 0 && weapon.ammo != 0 {
					let c = 1 - weapon.remainingCooldown / weapon.cooldown
					node.cooldownNode.progress.size.width = WeaponNode.cooldownSize.width * CGFloat(c)
				} else {
					node.cooldownNode.progress.size.width = 0
				}
			}
			else {
				node.cooldownNode.progress.size.width = WeaponNode.cooldownSize.width
			}
		} else {
			node.alpha = 0
		}
	}
}
