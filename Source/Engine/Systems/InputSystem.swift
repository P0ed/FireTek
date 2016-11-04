import SpriteKit
import PowerCore
import Fx
import Runes

struct InputSystem {

	private let updateInput: Closure<VehicleInputComponent?>
	private let inputController: InputController
	private let world: World

	init(world: World, player: Entity, inputController: InputController) {
		self.world = world
		self.inputController = inputController
		updateInput = world.vehicleInput.weakClosure(player)
	}

	func update() {
		updateInput.value = inputController.currentInput()
	}
}
