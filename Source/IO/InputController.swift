import Fx

final class InputController {
	let hid: HIDController

	@IO private var ls = Point(x: 0, y: 0)
	@IO private var rs = Point(x: 0, y: 0)
	private var buttonsState: Int = 0

	init(_ hid: HIDController) {
		self.hid = hid

		let buttonAction: (DSButton) -> (Bool) -> Void = { button in { pressed in
			if pressed {
				self.buttonsState |= 1 << button.rawValue
			} else {
				self.buttonsState &= ~(1 << button.rawValue)
			}
		}}

		hid.map = ControlsMap(
			buttonsMapTable: [
				.square: buttonAction(.square),
				.triangle: buttonAction(.triangle),
				.cross: buttonAction(.cross),
				.circle: buttonAction(.circle),
				.l1: buttonAction(.l1),
				.r1: buttonAction(.r1)
			],
			dPadMapTable: [:],
			sticksMapTable: [
				.left: _ls.set,
				.right: _rs.set
			],
			keyboardMapTable: [:]
		)
	}

	func buttonPressed(_ button: DSButton) -> Bool {
		return buttonsState & 1 << button.rawValue != 0
	}
}

extension InputController {

	var currentInput: VehicleInputComponent {
		VehicleInputComponent(
			accelerate: .init(ls.y),
			turnHull: .init(ls.x),
			turnTurret: .init(rs.x),
			primary: buttonPressed(.r1),
			secondary: buttonPressed(.l1)
		)
	}
}
