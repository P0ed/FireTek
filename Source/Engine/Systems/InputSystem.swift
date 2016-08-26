import PowerCore
import Fx

struct InputSystem {

	private let updateInput: Closure<VehicleInputComponent>.Setter?
	private let inputController: InputController

	init(world: World, player: Entity, inputController: InputController) {
		self.inputController = inputController
		updateInput = {world.vehicleInput.closureAt($0).set} <^> world.vehicleInput.indexOf(player)
	}

	func update() {
		updateInput?(inputController.currentInput())
	}
}
