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

//import Foundation
//
//class EventsController {
//
//	lazy var deviceConfiguration = ControllerMap()
//
//	var leftJoystick = DSVector.zeroVector
//	var rightJoystick = DSVector.zeroVector
//	var leftTrigger = 0.0
//	var rightTrigger = 0.0
//	var hatDirection = DSHatDirection.null
//
//	func handleEvent(_ event: Any) {
//		switch event.type.rawValue {
//		case OEHIDEventTypeHatSwitch.rawValue:
//			if let hatDirection = DSHatDirection(rawValue: Int(event.hatDirection.rawValue)) {
//				let buttons = changedStateDPadButtons(self.hatDirection, current: hatDirection)
//				self.hatDirection = hatDirection
//
//				func performActions(_ buttons: [DSHatDirection], pressed: Bool) {
//					buttons.forEach { button in
//						if let action = deviceConfiguration.dPadMapTable[button] {
//							action.performAction(pressed)
//						}
//					}
//				}
//
//				performActions(buttons.up, pressed: false)
//				performActions(buttons.down, pressed: true)
//			}
//		default: break
//		}
//	}
//}
//
//private func changedStateDPadButtons(_ previous: DSHatDirection, current: DSHatDirection) -> (up: [DSHatDirection], down: [DSHatDirection]) {
//	var up: [DSHatDirection] = []
//	var down: [DSHatDirection] = []
//
//	for i in 0...3 {
//		let bit = 1 << i
//		let was = previous.rawValue & bit
//		let now = current.rawValue & bit
//
//		if was != now {
//			if was != 0 {
//				up.append(DSHatDirection(rawValue: bit)!)
//			} else {
//				down.append(DSHatDirection(rawValue: bit)!)
//			}
//		}
//	}
//
//	return (up, down)
//}
