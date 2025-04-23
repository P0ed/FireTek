final class TargetSystem {
	private let world: World
	private let player: Entity
	private let messageSystem: MessageSystem

	init(world: World, player: Entity, messageSystem: MessageSystem) {
		self.world = world
		self.player = player
		self.messageSystem = messageSystem

		scan(entity: player)
	}

	func update() {
		let refs = world.shipRefs as Store<ShipRef>

		for index in refs.indices {
			if let target = refs[index].target, !refs.entityManager.isAlive(target) {
				refs[index].target = nil
			}
		}
	}

	func scan(entity: Entity) {
		guard let phy = world.physics[entity] else { return }

		messageSystem.clearSystemMessages(.target)

		var targets = [] as [Entity]
		for idx in world.shipRefs.indices {
			let ref = world.shipRefs[idx]
			let p = world.physics[ref.physics]
			if p.category.isSuperset(of: [.ship, phy.category.team?.opposite.category ?? []]) {
				let target = world.physics.entityAt(idx)
				targets.append(target)
				messageSystem.send(Message(system: .target, target: target, text: ref.info))
			}
		}
	}
}
