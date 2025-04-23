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
}
