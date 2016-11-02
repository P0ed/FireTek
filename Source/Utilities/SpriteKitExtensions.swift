import SpriteKit
import ObjectiveC.runtime
import PowerCore

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

	var transform: Transform {
		set {
			self.position = CGPoint(x: CGFloat(newValue.x), y: CGFloat(newValue.y))
			self.zRotation = CGFloat(newValue.zRotation)
		}
		get {
			let position = self.position
			let zRotation = self.zRotation
			return Transform(
				x: Float(position.x),
				y: Float(position.y),
				zRotation: Float(zRotation)
			)
		}
	}
}
