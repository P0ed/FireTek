import Fx
import SpriteKit

final class HUDSystem {
	private let world: World
	private let hudNode: HUDNode

	private var playerSprite: WeakRef<SpriteComponent>?
	private var playerPhysics: WeakRef<PhysicsComponent>?

	private var mapNodes: [(SKNode, SKNode)] = []

	private var playerTarget: WeakRef<TargetComponent>?
	private var targetStats: WeakRef<ShipStats>?

	private var playerStats: WeakRef<ShipStats>?
	private var primaryWeapon: WeakRef<WeaponComponent>?
	private var secondaryWeapon: WeakRef<WeaponComponent>?

	private let disposable = SerialDisposable()

	init(world: World, player: Entity, hudNode: HUDNode) {
		self.world = world
		self.hudNode = hudNode

		playerSprite = world.sprites.weakRefOf(player)
		playerPhysics = world.physics.weakRefOf(player)
		playerTarget = world.targets.weakRefOf(player)
		playerStats = world.shipStats.weakRefOf(player)
		primaryWeapon = world.primaryWpn.weakRefOf(player)
		secondaryWeapon = world.secondaryWpn.weakRefOf(player)

		disposable.innerDisposable = observeMap(mapItems: world.mapItems)
	}

	private func observeMap(mapItems: Store<MapItem>) -> Disposable {
		let d = CompositeDisposable()
		let map = hudNode.map

		let add = { [unowned self] (idx: Int) in
			let item = mapItems[idx]
			let mapSprite = SKShapeNode(circleOfRadius: 1)
			mapSprite.fillColor = item.type.color
			mapSprite.strokeColor = .clear
			mapSprite.zPosition = item.type == .ally ? 2 : item.type == .enemy ? 1 : 0
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

		let stats = playerStats?.value
		updateHPNode(node: hudNode.playerHP, hp: stats?.hp)
		updateHPNode(node: hudNode.targetHP, hp: targetStats?.value?.hp)

		updateWeaponNode(node: hudNode.weapon1, weapon: primaryWeapon?.value)
		updateWeaponNode(node: hudNode.weapon2, weapon: secondaryWeapon?.value)

		updateBar(node: hudNode.capacitor, progress: stats?.reactor.normalized ?? 1)
		updateBar(node: hudNode.shield, progress: stats?.shield.normalized ?? 1)

		updateMap()

		if let physics = playerPhysics?.value {
			let x = Int(physics.position.x)
			let y = Int(physics.position.y)
			let dx = Int(physics.momentum.dx * 60)
			let dy = Int(physics.momentum.dy * 60)

			hudNode.playerHP.label.text = "x: \(x), y: \(y), dx: \(dx), dy: \(dy)"
		}
	}

	private func fillHud() {
		if let target = playerTarget?.value?.target {
			if targetStats?.entity != target {
				targetStats = world.shipStats.weakRefOf(target)
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

	private func updateWeaponNode(node: BarNode, weapon: WeaponComponent?) {
		if let weapon = weapon {
			node.alpha = 1

			if weapon.remainingCooldown > 0 {
				if weapon.rounds == 0 {
					let c: CGFloat = 1 - CGFloat(weapon.remainingCooldown) / CGFloat(weapon.cooldown)
					node.progress.size.width = BarNode.size.width * c
				} else {
					node.progress.size.width = 0
				}
			} else {
				node.progress.size.width = BarNode.size.width
			}
		} else {
			node.alpha = 0
		}
	}

	private func updateBar(node: BarNode, progress: CGFloat) {
		node.progress.size.width = BarNode.size.width * progress
	}

	private func updateMap() {
		let playerNode = playerSprite?.value?.sprite
		guard let center = playerNode?.position else { return mapNodes.forEach { $0.1.isHidden = true } }

		for (node, mapNode) in mapNodes {
			let pos = node.position
			let v = (pos - center).vector
			let l = v.length
			let s = max(48, l / 32)
			mapNode.position = (v / s).point
			mapNode.isHidden = l > 8000
		}
	}
}

extension MapItem.ItemType {
	var color: SKColor {
		switch self {
		case .star: return SKColor(hex: 0x999911)
		case .planet: return SKColor(hex: 0x119944)
		case .ally: return SKColor(hex: 0x1122AA)
		case .enemy: return SKColor(hex: 0xCC1111)
		}
	}
}
