final class TargetSystem {
	let world: World
	let player: Entity
	let inputController: InputController

	private var pressed = false

	init(world: World, player: Entity, inputController: InputController) {
		self.world = world
		self.player = player
		self.inputController = inputController
	}

	func update() {
		let targets = world.targets as Store<TargetComponent>
		var playerTargetIndex = nil as Int?
		var playerTarget: TargetComponent? {
			playerTargetIndex.map { targets[$0] }
		}

		for index in targets.indices {
			if let target = targets[index].target, !targets.entityManager.isAlive(target) {
				targets[index].target = nil
			}

			if targets.entityAt(index) == player {
				playerTargetIndex = index
			}
		}

		let input = inputController.currentInput
		if !pressed, input.target {
			pressed = true

			let target = world.shipRefs.first { ship in
				let e = world.sprites.entityAt(ship.sprite.box.value)
				return e != player && e != playerTarget?.target
			}
			.map {
				world.sprites.entityAt($0.sprite.box.value)
			}
			if let target, let idx = playerTargetIndex {
				world.targets[idx].target = target
			}

		} else if pressed, !input.target {
			pressed = false
		}
	}
}
