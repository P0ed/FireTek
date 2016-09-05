import SpriteKit
import PowerCore
import Fx

struct InputSystem {

	private let updateInput: Closure<VehicleInputComponent>?
	private let inputController: InputController
	private let world: World

	init(world: World, player: Entity, inputController: InputController) {
		self.world = world
		self.inputController = inputController
		updateInput = world.vehicleInput.closureAt <^> world.vehicleInput.indexOf(player)
	}

	func update() {
		updateInput?.value = inputController.currentInput()
	}
}
