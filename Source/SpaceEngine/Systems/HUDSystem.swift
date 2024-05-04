import Fx
import SpriteKit

final class HUDSystem {

	private let world: World
	private let hudNode: HUDNode

	private var playerSprite: WeakRef<SpriteComponent>?
	private var mapNodes: [(SKNode, SKNode)] = []

	private var playerHP: WeakRef<HPComponent>?
	private var playerTarget: WeakRef<TargetComponent>?
	private var targetHP: WeakRef<HPComponent>?

	private var primaryWeapon: WeakRef<WeaponComponent>?
	private var secondaryWeapon: WeakRef<WeaponComponent>?

	private let disposable = SerialDisposable()

	init(world: World, player: Entity, hudNode: HUDNode) {
		self.world = world
		self.hudNode = hudNode

		playerSprite = world.sprites.weakRefOf(player)
		playerHP = world.hp.weakRefOf(player)
		playerTarget = world.targets.weakRefOf(player)
		primaryWeapon = world.primaryWpn.weakRefOf(player)
		secondaryWeapon = world.secondaryWpn.weakRefOf(player)

		disposable.innerDisposable = observeMap(mapItems: world.mapItems)
	}

	private func observeMap(mapItems: Store<MapItem>) -> Disposable {
		let d = CompositeDisposable()
		let map = hudNode.map

		let add = { [unowned self] (idx: Int) in
			let item = mapItems[idx]
			let mapSprite = SKShapeNode(circleOfRadius: 2)
			mapSprite.fillColor = item.type.color
			mapSprite.strokeColor = .clear
			map.addChild(mapSprite)
			self.mapNodes.append((item.node, mapSprite))
		}

		mapItems.indices.forEach(add)

		d += mapItems.newComponents.observe(add)

		d += mapItems.removedComponents.observe { [unowned self] _, item in
			if let idx = self.mapNodes.firstIndex(where: { $0.0 === item.node }) {
				self.mapNodes.remove(at: idx).1.removeFromParent()
			}
		}

		return d
	}

	func update() {
		fillHud()

		updateHPNode(node: hudNode.playerHP, hp: playerHP?.value)
		updateHPNode(node: hudNode.targetHP, hp: targetHP?.value)

		updateWeaponNode(node: hudNode.weapon1, weapon: primaryWeapon?.value)
		updateWeaponNode(node: hudNode.weapon2, weapon: secondaryWeapon?.value)

		updateMap()
	}

	private func fillHud() {
		if let target = playerTarget?.value?.target {
			if targetHP?.entity != target {
				targetHP = world.hp.weakRefOf(target)
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

	private func updateMap() {
		let playerNode = playerSprite?.value?.sprite
		guard let center = playerNode?.position else { return mapNodes.forEach { $0.1.isHidden = true } }

		let scale = 48 as CGFloat
		let r = 42 * scale	/// mapRadius - itemRadius

		let isInside = { (p: CGPoint) -> Bool in
			let x = (p.x - center.x) * (p.x - center.x) + (p.y - center.y) * (p.y - center.y)
			let y = r * r
			return x < y
		}

		for (node, mapNode) in mapNodes {
			let pos = node.position
			let x = (pos.x - center.x) / scale
			let y = (pos.y - center.y) / scale
			mapNode.position = CGPoint(x: x, y: y)
			mapNode.isHidden = !isInside(pos)
		}
	}
}

extension MapItem.ItemType {
	var color: SKColor {
		switch self {
		case .star: return SKColor(hex: 0xaaaa11)
		case .planet: return SKColor(hex: 0x11aa44)
		case .ally: return SKColor(hex: 0x1122cc)
		case .enemy: return SKColor(hex: 0xee1111)
		}
	}
}
