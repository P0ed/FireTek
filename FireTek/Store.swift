import Fx

typealias StoreID = UInt16

final class Store<Component> {
	typealias Index = Int

	private weak var entityManager: EntityManager?

	private let id: StoreID
	private var entities: ContiguousArray<Entity> = []
	private var components: ContiguousArray<Component> = []
	private var indexes: ContiguousArray<MutableBox<Index>> = []
	private var map: [Entity: Index] = [:]

	init(id: StoreID, entityManager: EntityManager) {
		self.id = id
		self.entityManager = entityManager
	}

	func sharedIndexAt(idx: Index) -> Box<Index> {
		return indexes[idx].box
	}

	func indexOf(entity: Entity) -> Index? {
		return map[entity]
	}

	subscript(idx: Index) -> Component {
		get {
			return components[idx]
		}
		set(component) {
			components[idx] = component
		}
	}

	func add(component: Component, to entity: Entity) -> Box<Index> {
		let idx = components.count
		let sharedIdx = MutableBox(idx)

		entities.append(entity)
		components.append(component)
		indexes.append(sharedIdx)
		map[entity] = idx

		entityManager?.setRemoveHandle(entity, storeID: id) { [weak self] in
			self?.removeAt(sharedIdx.value)
		}

		return sharedIdx.box
	}

	func removeAt(idx: Index) {
		let entity = entities[idx]
		let lastIndex = entities.endIndex.predecessor()
		let lastEntity = entities[lastIndex]

		entities[idx] = entities[lastIndex]
		entities.removeLast()

		components[idx] = components[lastIndex]
		components.removeLast()

		let sharedIndex = indexes[lastIndex]
		sharedIndex.value = idx
		indexes[idx] = sharedIndex
		indexes.removeLast()

		map[lastEntity] = idx
		map.removeValueForKey(entity)

		entityManager?.setRemoveHandle(entity, storeID: id, handle: nil)
	}
}
