import Foundation
import OpenEmuSystem
import Runes

class HIDController {

	let eventsController = EventsController()
	private var eventMonitors: [UInt: Any] = [:]

	init() {
		let deviceManager = OEDeviceManager.shared()
		let notificationCenter = NotificationCenter.default
		let didAddDeviceKey = NSNotification.Name.OEDeviceManagerDidAddDeviceHandler
		let didRemoveDeviceKey = NSNotification.Name.OEDeviceManagerDidRemoveDeviceHandler

		notificationCenter.addObserver(forName: didAddDeviceKey, object: nil, queue: OperationQueue.main) { [unowned self] note in
			let deviceHandler = (note as NSNotification).userInfo![OEDeviceManagerDeviceHandlerUserInfoKey] as! OEDeviceHandler
			self.eventMonitors[deviceHandler.deviceIdentifier] = deviceManager?.addEventMonitor(for: deviceHandler) { _, event in
				_ = self.eventsController.handleEvent <^> event
			}
		}

		notificationCenter.addObserver(forName: didRemoveDeviceKey, object: nil, queue: OperationQueue.main) { [unowned self] note in
			let deviceHandler = (note as NSNotification).userInfo![OEDeviceManagerDeviceHandlerUserInfoKey] as! OEDeviceHandler
			self.eventMonitors.removeValue(forKey: deviceHandler.deviceIdentifier)
		}
	}
}
