final class InputController {

	let eventsController: EventsController

	private var buttonsState: Int = 0

	init(_ eventsController: EventsController) {
		self.eventsController = eventsController

		let buttonAction: DSButton -> DeviceAction = {
			button in
			return DeviceAction {
				pressed in
				if pressed {
					self.buttonsState |= 1 << button.rawValue
				} else {
					self.buttonsState &= ~(1 << button.rawValue)
				}
			}
		}

		let buttonActions: [DSButton: DeviceAction] = [
			.Square: buttonAction(.Square),
			.Cross: buttonAction(.Cross),
			.Circle: buttonAction(.Circle)
		]

		eventsController.deviceConfiguration = DeviceConfiguration(
			buttonsMapTable: buttonActions,
			dPadMapTable: [:],
			keyboardMapTable: [:]
		)
	}

	func buttonPressed(button: DSButton) -> Bool {
		return buttonsState & 1 << button.rawValue != 0
	}
}

extension InputController {
	func currentInput() -> VehicleInputComponent {
		return VehicleInputComponent(
			accelerate: .init(eventsController.leftJoystick.dy),
			turnHull: .init(eventsController.leftJoystick.dx),
			turnTurret: .init(eventsController.rightJoystick.dx),
			primaryFire: buttonPressed(.Cross),
			secondaryFire: buttonPressed(.Square),
			special: buttonPressed(.Circle)
		)
	}
}
