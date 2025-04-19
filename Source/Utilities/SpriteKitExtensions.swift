import SpriteKit
import ObjectiveC.runtime

extension SKNode {

	private static let entityContainerKey = UnsafeMutablePointer<Int8>.allocate(capacity: 1)

	var entity: Entity? {
		get {
			return objc_getAssociatedObject(self, SKNode.entityContainerKey) as? Entity
		}
		set {
			objc_setAssociatedObject(self, SKNode.entityContainerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
}

extension SKColor {

	convenience init(hex: Int) {
		self.init(
			red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(hex & 0x0000FF) / 255.0,
			alpha: 1
		)
	}
}
