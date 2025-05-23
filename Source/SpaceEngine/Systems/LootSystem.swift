import SpriteKit
import Fx

final class LootSystem {
	fileprivate let world: World
	private let collisionsSystem: CollisionsSystem
	private let disposable = CompositeDisposable()

	init(world: World, collisionsSystem: CollisionsSystem) {
		self.world = world
		self.collisionsSystem = collisionsSystem

		disposable += collisionsSystem.didBeginContact.observe {
			[weak self] in self?.processContact($0)
		}
	}

	func update() {
		spawnLoot()
	}

	private func spawnLoot() {
		for index in world.dead.indices {
			let entity = world.dead.entityAt(index)
			if let lootIndex = world.loot.indexOf(entity),
				let phyIndex = world.physics.indexOf(entity) {
				spawnLoot(
					loot: world.loot[lootIndex],
					at: world.physics[phyIndex].position
				)
			}
		}
	}

	private func spawnLoot(loot: LootComponent, at position: CGPoint) {
		let count = Int(arc4random_uniform(UInt32(loot.count))) + 1
		let units = world.unitFactory
		for index in 0..<count {
			let offset = spread(at: index, outOf: count)
			let crystal = generate(base: loot.crystal)

			units.addCrystal(crystal: crystal, at: position, moveBy: offset)
		}
	}

	private func spread(at index: Int, outOf count: Int) -> CGVector {
		if count == 1 { return .zero }
		let angle = CGFloat.pi * 2 / CGFloat(count)
		let r = CGVector(dx: 0, dy: 12)
		return r.rotate(angle * CGFloat(index))
	}

	private func generate(base: Crystal) -> Crystal {
		switch Int(arc4random_uniform(20)) {
		case 0...1: return .red
		case 2...3: return .green
		case 4...5: return .blue
		case 5...7: return .purple
		case 8: return .yellow
		case 9: return .cyan
		case 10: return .orange
		default: return base
		}
	}
}

private extension LootSystem {

	func processContact(_ contact: Contact) {
		guard let loot = world.crystals.first(contact.a, contact.b) else { return }

		world.entityManager.removeEntity(loot.entity)

		let e = loot.entity == contact.a ? contact.b : contact.a
		world.physics.refOf(e)?.value.node.run(.play(.crystalCollected))
	}
}
