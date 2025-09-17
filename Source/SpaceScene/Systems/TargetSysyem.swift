final class TargetSystem {
	private let world: World
	private let player: Entity
	private let msgsys: MessageSystem

	init(world: World, msgsys: MessageSystem) {
		self.world = world
		self.player = world.players[0]
		self.msgsys = msgsys

		scan(entity: player)
	}

	func update() {
		let ships = world.ships as Store<Ship>

		for index in ships.indices {
			if let target = ships[index].target, !ships.entityManager.isAlive(target) {
				ships[index].target = nil
			}
		}
	}

	func scan(entity: Entity) {
		guard let phy = world.physics[entity] else { return }

		msgsys.clearSystemMessages(.target)

		var targets = [] as [Entity]
		for idx in world.shipRefs.indices {
			let ref = world.shipRefs[idx]
			let p = world.physics[ref.physics]
			if p.category.isSuperset(of: [.ship, phy.category.team?.opposite.category ?? []]) {
				let target = world.shipRefs.entityAt(idx)
				targets.append(target)
				msgsys.send(Message(system: .target, target: target, text: ref.info))
			}
		}
		if targets.isEmpty {
			msgsys.send(Message(system: .target, text: world[0].text))
		}
	}
}
