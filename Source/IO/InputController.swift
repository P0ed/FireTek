import Fx

final class InputController {
	let hid: HIDController

	@IO private var pressedButtons: Int = 0
	@IO private var dpad: DPad = .null

	var input: Input = .empty
	var transform: (Input) -> Input = { $0 }

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
			dpad: _dpad.set,
			keyboardMapTable: [
				0x7B: { [_dpad] in _dpad.value.left = $0 },
				0x7C: { [_dpad] in _dpad.value.right = $0 },
				0x7D: { [_dpad] in _dpad.value.down = $0 },
				0x7E: { [_dpad] in _dpad.value.up = $0 },
				0x6: buttonAction(.cross),
				0x7: buttonAction(.circle),
				0x8: buttonAction(.r1),
				0x0: buttonAction(.square),
				0x1: buttonAction(.triangle),
				0x2: buttonAction(.l1),
			]
		)
	}

	func readInput() -> Input {
		input = transform(Input(
			dpad: dpad,
			primary: buttonPressed(.r1),
			secondary: buttonPressed(.l1),
			impulse: buttonPressed(.cross),
			warp: buttonPressed(.circle),
			action: buttonPressed(.square),
			scan: buttonPressed(.triangle)
		))
		return input
	}
}

extension InputController {

	private func buttonPressed(_ button: DSButton) -> Bool {
		pressedButtons & 1 << button.rawValue != 0
	}
}
