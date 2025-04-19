import GameController
import Fx

struct ControlsMap {
	var buttonsMapTable: [DSButton: (Bool) -> Void] = [:]
	var dpad: (DPad) -> Void = { _ in }
	var keyboardMapTable: [UInt16: (Bool) -> Void] = [:]
}

final class HIDController {
	private let lifetime: Any

	@IO var map = ControlsMap()

	init() {
		lifetime = [
			NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .keyUp]) { [_map] e in
				if let action = _map.value.keyboardMapTable[e.keyCode] {
					action(e.type == .keyDown)
					return nil
				} else {
					return e
				}
			} as Any,
			NotificationCenter.default.addObserver(
				forName: .GCControllerDidBecomeCurrent,
				object: nil,
				queue: .main,
				using: { [_map] notification in
					guard let gamepad = (notification.object as? GCController)?.extendedGamepad else { return }

					gamepad.dpad.valueChangedHandler = { dpad, _, _ in
						_map.value.dpad(dpad.dpad)
					}
					gamepad.leftShoulder.pressedChangedHandler = { _, _, pressed in
						_map.value.buttonsMapTable[.l1]?(pressed)
					}
					gamepad.rightShoulder.pressedChangedHandler = { _, _, pressed in
						_map.value.buttonsMapTable[.r1]?(pressed)
					}
					gamepad.buttonA.pressedChangedHandler = { _, _, pressed in
						_map.value.buttonsMapTable[.cross]?(pressed)
					}
					gamepad.buttonB.pressedChangedHandler = { _, _, pressed in
						_map.value.buttonsMapTable[.circle]?(pressed)
					}
					gamepad.buttonX.pressedChangedHandler = { _, _, pressed in
						_map.value.buttonsMapTable[.square]?(pressed)
					}
					gamepad.buttonY.pressedChangedHandler = { _, _, pressed in
						_map.value.buttonsMapTable[.triangle]?(pressed)
					}
				}
			)
		]
	}
}

extension GCControllerDirectionPad {
	var dpad: DPad {
		var dpad = DPad.null
		dpad.up = up.isPressed
		dpad.right = `right`.isPressed
		dpad.down = down.isPressed
		dpad.left = `left`.isPressed
		return dpad
	}
}
