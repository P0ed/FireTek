import SpriteKit
import ObjectiveC.runtime
import PowerCore

extension SKNode {

	private final class EntityContainer {

		fileprivate static let key = UnsafeMutablePointer<Int8>.allocate(capacity: 1)

		let entity: Entity

		init(_ entity: Entity) {
			self.entity = entity
		}
	}

	var entity: Entity? {
		get {
			return (objc_getAssociatedObject(self, EntityContainer.key) as? EntityContainer)?.entity
		}
		set {
			objc_setAssociatedObject(self, EntityContainer.key, newValue.map(EntityContainer.init), .OBJC_ASSOCIATION_RETAIN)
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
