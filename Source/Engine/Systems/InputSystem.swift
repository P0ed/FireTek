import SpriteKit
import PowerCore
import Fx
import Runes

struct InputSystem {

	private let playerInput: WeakRef<ShipInputComponent>?
	private let inputController: InputController
	private let world: World

	init(world: World, player: Entity, inputController: InputController) {
		self.world = world
		self.inputController = inputController
		playerInput = world.shipInput.weakRefAt <^> world.shipInput.indexOf(player)
	}

	func update() {
		playerInput?.value = inputController.currentInput()
	}
}
