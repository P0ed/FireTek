import Carbon.HIToolbox

final class InputController {

	let eventsController: EventsController

	private var buttonsState: Int = 0

	init(_ eventsController: EventsController) {
		self.eventsController = eventsController

		let buttonAction: (DSButton) -> DeviceAction = { button in
			return DeviceAction { pressed in
				if pressed {
					self.buttonsState |= 1 << button.rawValue
				} else {
					self.buttonsState &= ~(1 << button.rawValue)
				}
			}
		}

		let buttonActions: [DSButton: DeviceAction] = [
			.square: buttonAction(.square),
			.cross: buttonAction(.cross),
			.circle: buttonAction(.circle)
		]

		let keyboardActions: [Int: DeviceAction] = [
			DeviceConfiguration.keyCode(forVirtualKey: kVK_ANSI_Q): buttonAction(.square),
			DeviceConfiguration.keyCode(forVirtualKey: kVK_ANSI_W): buttonAction(.cross),
			DeviceConfiguration.keyCode(forVirtualKey: kVK_ANSI_E): buttonAction(.circle),
			DeviceConfiguration.keyCode(forVirtualKey: kVK_UpArrow): DeviceAction { pressed in
				eventsController.leftJoystick.dy = pressed ? 1 : 0
			},
			DeviceConfiguration.keyCode(forVirtualKey: kVK_DownArrow): DeviceAction { pressed in
				eventsController.leftJoystick.dy = pressed ? -1 : 0
			},
			DeviceConfiguration.keyCode(forVirtualKey: kVK_LeftArrow): DeviceAction { pressed in
				eventsController.leftJoystick.dx = pressed ? -1 : 0
			},
			DeviceConfiguration.keyCode(forVirtualKey: kVK_RightArrow): DeviceAction { pressed in
				eventsController.leftJoystick.dx = pressed ? 1 : 0
			}
		]

		eventsController.deviceConfiguration = DeviceConfiguration(
			buttonsMapTable: buttonActions,
			dPadMapTable: [:],
			keyboardMapTable: keyboardActions
		)
	}

	func buttonPressed(_ button: DSButton) -> Bool {
		return buttonsState & 1 << button.rawValue != 0
	}
}

extension InputController {
	func currentInput() -> VehicleInputComponent {
		return VehicleInputComponent(
			accelerate: .init(eventsController.leftJoystick.dy),
			turnHull: .init(eventsController.leftJoystick.dx),
			turnTurret: .init(eventsController.rightJoystick.dx),
			primaryFire: buttonPressed(.square),
			secondaryFire: buttonPressed(.cross),
			special: buttonPressed(.circle)
		)
	}
}
