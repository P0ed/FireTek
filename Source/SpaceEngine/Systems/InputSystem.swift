import SpriteKit
import Fx

final class InputSystem {
	private let playerInput: WeakRef<InputComponent>?
	private let inputController: InputController
	private let world: World
	private var action = false

	init(world: World, player: Entity, inputController: InputController) {
		self.world = world
		self.inputController = inputController
		playerInput = world.input.weakRefOf(player)
	}

	func update() {
		let input = inputController.currentInput
		playerInput?.value = input

		if input.action, !action {
			action = true

		} else if !input.action, action {
			action = false
		}
	}
}
