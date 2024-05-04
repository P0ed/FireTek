import Foundation
import GameController
import Fx

struct ControlsMap {
	var buttonsMapTable: [DSButton: (Bool) -> Void] = [:]
	var dPadMapTable: [DSHatDirection: (Bool) -> Void] = [:]
	var sticksMapTable: [DSStick: (Point) -> Void] = [:]
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

					gamepad.leftThumbstick.valueChangedHandler = { _, x, y in
						_map.value.sticksMapTable[.left]?(Point(x: x, y: y))
					}
					gamepad.rightThumbstick.valueChangedHandler = { _, x, y in
						_map.value.sticksMapTable[.right]?(Point(x: x, y: y))
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
