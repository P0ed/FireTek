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

struct Entity: Hashable {
	private var id: UInt64

	var generation: UInt32 {
		return UInt32(id >> 32)
	}
	var index: UInt32 {
		return UInt32(id & Entity.mask)
	}

	init(generation: UInt32, index: UInt32) {
		id = UInt64(generation) << 32 | UInt64(index)
	}

	var next: UInt32 {
		return generation < .max ? generation + 1 : 0
	}

	static let mask: UInt64 = (1 << 32) - 1
}

final class EntityManager {
	typealias RemoveHandle = () -> ()

	private var generation: [UInt32] = []
	private var freeIndices: [UInt32] = []
	private var removeHandles: [Entity: [StoreID: RemoveHandle]] = [:]

	func create() -> Entity {
		if freeIndices.count > 0 {
			let index = freeIndices.removeLast()
			return Entity(generation: generation[Int(index)], index: index)
		} else {
			let entity = Entity(generation: 0, index: UInt32(generation.count))
			generation.append(entity.generation)
			return entity
		}
	}

	func removeEntity(_ entity: Entity) {
		if generation[Int(entity.index)] == entity.generation {

			if let handles = removeHandles.removeValue(forKey: entity) {
				for handle in handles.values {
					handle()
				}
			}

			generation[Int(entity.index)] = entity.next
			freeIndices.append(entity.index)
		}
	}

	func isAlive(_ entity: Entity) -> Bool {
		return generation[Int(entity.index)] == entity.generation
	}

	func setRemoveHandle(entity: Entity, storeID: StoreID, handle: RemoveHandle?) {
		var handles = removeHandles[entity] ?? [:]
		handles[storeID] = handle
		removeHandles[entity] = handles
	}
}
