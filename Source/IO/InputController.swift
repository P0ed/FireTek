import Fx

final class InputController {
	let hid: HIDController

	@IO private var pressedButtons: Int = 0
	@IO private var dpad: DPad = .null

	init(_ hid: HIDController) {
		self.hid = hid

		let buttonAction: (DSButton) -> (Bool) -> Void = { [_pressedButtons] button in { pressed in
			if pressed {
				_pressedButtons.value |= 1 << button.rawValue
			} else {
				_pressedButtons.value &= ~(1 << button.rawValue)
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
			dpad: _dpad.set
		)
	}
}

extension InputController {

	private func buttonPressed(_ button: DSButton) -> Bool {
		pressedButtons & 1 << button.rawValue != 0
	}

	var currentInput: InputComponent {
		InputComponent(
			dpad: dpad,
			primary: buttonPressed(.r1),
			secondary: buttonPressed(.l1),
			impulse: buttonPressed(.cross),
			target: buttonPressed(.circle),
			action: buttonPressed(.square),
			warp: buttonPressed(.triangle)
		)
	}
}
