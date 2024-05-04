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
