import SpriteKit
import Fx

final class InputSystem {
	private let playerInput: WeakRef<Input>?
	private let world: World
	private var acting = false
	private var scanning = false

	var scan = {}
	var action = {}

	init(world: World, player: Entity) {
		self.world = world
		playerInput = world.input.weakRefOf(player)

		scan = { [weak self] in self?.scan(entity: player) }
	}

	func update(input: Input) {
		playerInput?.value = input

		if input.action, !acting {
			acting = true
			action()
		} else if !input.action, acting {
			acting = false
		}
		if !scanning, input.scan {
			scanning = true
			scan()
		} else if scanning, !input.scan {
			scanning = false
		}
	}

	func scan(entity: Entity) {
		guard let phy = world.physics[entity] else { return }

		var targets = [] as [Entity]
		for idx in world.physics.indices {
			let p = world.physics[idx]
			if p.category.isSuperset(of: [.ship, phy.category.team?.opposite.category ?? []]) {
				targets.append(world.physics.entityAt(idx))
			}
		}

//		world.targets[entity]?.target =
//		let target = world.shipRefs.indices.first {
//			let e = world.shipRefs.entityAt($0)
//			return e != player && e != playerTarget?.target
//		}
//			.map(world.shipRefs.entityAt)
//
//		if let target, let idx = playerTargetIndex {
//			world.targets[idx].target = target
//			postMessage(target: target)
//		}
	}

//	func postMessage(target: Entity) {
//		if let message {
//			world.messages.removeAt(message.box.value)
//		}
//		if let shipInfo = world.messages[target] {
//			let idx = world.messages.add(component: Message(from: system, to: player, text: shipInfo.text), to: system)
//			self.message = world.messages.sharedIndexAt(idx)
//		}
//	}
}
