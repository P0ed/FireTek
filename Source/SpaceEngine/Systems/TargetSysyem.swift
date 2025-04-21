final class TargetSystem {
	private let world: World
	private let player: Entity
	private let system: Entity
	private var message: ComponentIdx<Message>?
	private var pressed = false

	init(world: World, player: Entity) {
		self.world = world
		self.player = player
		self.system = world.entityManager.create()
	}

	func update(input: Input) {
		let targets = world.targets as Store<TargetComponent>
		var playerTargetIndex = nil as Int?

		for index in targets.indices {
			if let target = targets[index].target, !targets.entityManager.isAlive(target) {
				targets[index].target = nil
			}

			if targets.entityAt(index) == player { playerTargetIndex = index }
		}

		var playerTarget: TargetComponent? { playerTargetIndex.map { targets[$0] } }

		if !pressed, input.target {
			pressed = true

			let target = world.shipRefs.indices.first {
				let e = world.shipRefs.entityAt($0)
				return e != player && e != playerTarget?.target
			}
			.map(world.shipRefs.entityAt)

			if let target, let idx = playerTargetIndex {
				world.targets[idx].target = target
				postMessage(target: target)
			}

		} else if pressed, !input.target {
			pressed = false
		}
	}

	func postMessage(target: Entity) {
		if let message {
			world.messages.removeAt(message.box.value)
		}
		if let shipInfo = world.messages[target] {
			let idx = world.messages.add(component: Message(from: system, to: player, text: shipInfo.text), to: system)
			self.message = world.messages.sharedIndexAt(idx)
		}
	}
}
