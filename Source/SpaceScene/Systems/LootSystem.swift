import SpriteKit
import Fx

final class LootSystem {
	fileprivate let world: World
	private let colsys: CollisionsSystem
	private let disposable = CompositeDisposable()

	init(world: World, colsys: CollisionsSystem) {
		self.world = world
		self.colsys = colsys

		disposable += colsys.didBeginContact.observe {
			[weak self] in self?.processContact($0)
		}
	}

	func update() {
		for index in world.dead.indices {
			let entity = world.dead.entityAt(index)
			if let lootIndex = world.crystalBank.indexOf(entity),
				let phyIndex = world.physics.indexOf(entity) {
				spawnLoot(
					loot: world.crystalBank[lootIndex],
					at: world.physics[phyIndex].position
				)
			}
		}
	}

	private func spawnLoot(loot: Array4<Crystal>, at position: CGPoint) {
		let count = loot.count
		let units = world.unitFactory
		for index in 0..<count {
			let offset = spread(at: index, outOf: count)
			let crystal = generate(base: loot[index])
			units.addCrystal(crystal: crystal, at: position, moveBy: offset)
		}
	}

	private func spread(at index: Int, outOf count: Int) -> CGVector {
		count == 1 ? .zero : CGVector(dx: 0, dy: 8)
			.rotate(CGFloat(index * 2) * .pi / CGFloat(count))
	}

	private func generate(base: Crystal) -> Crystal {
		switch Int(arc4random_uniform(24)) {
		case 0...3: return .red
		case 4...6: return .amber
		case 7...9: return .yellow
		case 9...10: return .cyan
		case 11...12: return .blue
		case 13: return .violet
		default: return base
		}
	}
}

private extension LootSystem {

	func processContact(_ contact: Contact) {
		let u = contact.acat.union(contact.bcat)
		guard u.contains(.crystal), u.contains(.ship) else { return }

		let loot = contact.acat.contains(.crystal) ? contact.a : contact.b
		let ship = contact.acat.contains(.ship) ? contact.a : contact.b

		guard let idx = world.crystalBank.indexOf(ship) else { return }

		defer { world.entityManager.removeEntity(loot) }

		if let crystal = world.crystals[loot] {
			if world.crystalBank[idx].count == 4, let index = world.players.firstIndex(of: ship) {
				world.crystalBank[idx].collect(in: &world[index])
			}
			if world.crystalBank[idx].count < 4 {
				world.crystalBank[idx].append(crystal)
				world.physics[ship]?.node.run(.play(.crystalCollected))
			}
		}
	}
}

extension Array4<Crystal> {

	mutating func collect(in state: inout PlayerState) {

		forEach { c in
			switch c {
			case .red: state.crystals.red += 1
			case .amber: state.crystals.amber += 1
			case .yellow: state.crystals.yellow += 1
			case .cyan: state.crystals.cyan += 1
			case .blue: state.crystals.blue += 1
			case .violet: state.crystals.violet += 1
			}
		}
		self = []
	}
}
