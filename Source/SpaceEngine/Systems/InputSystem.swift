import SpriteKit
import Fx

final class InputSystem {
	private let playerInput: WeakRef<Input>?
	private let world: World
	private var action = false

	init(world: World, player: Entity) {
		self.world = world
		playerInput = world.input.weakRefOf(player)
	}

	func update(input: Input) {
		playerInput?.value = input

		if input.action, !action {
			action = true

		} else if !input.action, action {
			action = false
		}
	}
}
