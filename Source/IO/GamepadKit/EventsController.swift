import Foundation
import OpenEmuSystem

class EventsController {

	lazy var deviceConfiguration = DeviceConfiguration(buttonsMapTable: [:], dPadMapTable: [:], keyboardMapTable: [:])

	var leftJoystick = DSVector.zeroVector
	var rightJoystick = DSVector.zeroVector
	var leftTrigger = 0.0
	var rightTrigger = 0.0
	var hatDirection = DSHatDirection.null

	func handleEvent(_ event: OEHIDEvent) {
		switch event.type.rawValue {
		case OEHIDEventTypeAxis.rawValue:
			switch event.axis.rawValue {
			case OEHIDEventAxisX.rawValue:
				leftJoystick.dx = event.value.native
			case OEHIDEventAxisY.rawValue:
				leftJoystick.dy = -event.value.native
			case OEHIDEventAxisZ.rawValue:
				rightJoystick.dx = event.value.native
			case OEHIDEventAxisRz.rawValue:
				rightJoystick.dy = -event.value.native
			default: break
			}
		case OEHIDEventTypeTrigger.rawValue:
			switch event.axis.rawValue {
			case OEHIDEventAxisRx.rawValue:
				leftTrigger = event.value.native
			case OEHIDEventAxisRy.rawValue:
				rightTrigger = event.value.native
			default: break
			}
		case OEHIDEventTypeButton.rawValue:
			if let button = DSButton(rawValue: Int(event.buttonNumber)), let action = deviceConfiguration.buttonsMapTable[button] {
				action.performAction(event.state == OEHIDEventStateOn)
			}
		case OEHIDEventTypeHatSwitch.rawValue:
			if let hatDirection = DSHatDirection(rawValue: Int(event.hatDirection.rawValue)) {
				let buttons = changedStateDPadButtons(self.hatDirection, current: hatDirection)
				self.hatDirection = hatDirection

				func performActions(_ buttons: [DSHatDirection], pressed: Bool) {
					buttons.forEach { button in
						if let action = deviceConfiguration.dPadMapTable[button] {
							action.performAction(pressed)
						}
					}
				}

				performActions(buttons.up, pressed: false)
				performActions(buttons.down, pressed: true)
			}
		case OEHIDEventTypeKeyboard.rawValue:
			if let action = deviceConfiguration.keyboardMapTable[Int(event.keycode)] {
				action.performAction(event.state == OEHIDEventStateOn)
			}
		default: break
		}
	}

	func controlForEvent(_ event: OEHIDEvent) -> DSControl? {
		var control: DSControl?

		switch event.type.rawValue {
		case OEHIDEventTypeAxis.rawValue:
			if event.axis.rawValue == OEHIDEventAxisX.rawValue || event.axis.rawValue == OEHIDEventAxisY.rawValue {
				control = .stick(.left)
			} else if event.axis.rawValue == OEHIDEventAxisZ.rawValue || event.axis.rawValue == OEHIDEventAxisRz.rawValue {
				control = .stick(.right)
			}
		case OEHIDEventTypeTrigger.rawValue:
			if event.axis.rawValue == OEHIDEventAxisRx.rawValue {
				control = .trigger(.left)
			} else if event.axis.rawValue == OEHIDEventAxisRy.rawValue {
				control = .trigger(.right)
			}
		case OEHIDEventTypeButton.rawValue:
			if let button = DSButton(rawValue: Int(event.buttonNumber)) {
				control = .button(button)
			}
		case OEHIDEventTypeHatSwitch.rawValue:
			if let hatDirection = DSHatDirection(rawValue: Int(event.hatDirection.rawValue)) {
				control = .dPad(hatDirection)
			}
		default: break
		}
		return control
	}
}

func changedStateDPadButtons(_ previous: DSHatDirection, current: DSHatDirection) -> (up: [DSHatDirection], down: [DSHatDirection]) {
	var up: [DSHatDirection] = []
	var down: [DSHatDirection] = []

	for i in 0...3 {
		let bit = 1 << i
		let was = previous.rawValue & bit
		let now = current.rawValue & bit

		if was != now {
			if was != 0 {
				up.append(DSHatDirection(rawValue: bit)!)
			} else {
				down.append(DSHatDirection(rawValue: bit)!)
			}
		}
	}

	return (up, down)
}
