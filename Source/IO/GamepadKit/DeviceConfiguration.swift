import Foundation
import OpenEmuSystem

struct DeviceConfiguration {

	var buttonsMapTable: [DSButton: DeviceAction]
	var dPadMapTable: [DSHatDirection: DeviceAction]
	var keyboardMapTable: [Int: DeviceAction]

	static func keyCode(forVirtualKey key: Int) -> Int {
		return Int(OEHIDEvent.keyCode(forVirtualKey: CGCharCode(key)))
	}
}
