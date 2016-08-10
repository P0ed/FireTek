struct Store<Component> {
	typealias Index = Int

	private var entities: ContiguousArray<Entity> = []
	private var components: ContiguousArray<Component> = []
	private var indexes: ContiguousArray<MutableBox<Index>> = []
	private var map: [Entity: Index] = [:]

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

	mutating func add(component: Component, to entity: Entity) -> Box<Index> {
		let idx = components.count
		let sharedIdx = MutableBox(idx)
		entities.append(entity)
		components.append(component)
		indexes.append(sharedIdx)
		map[entity] = idx

		return sharedIdx.box
	}

	mutating func removeAt(idx: Index) {
		let lastIndex = entities.endIndex.predecessor()

		entities[idx] = entities[lastIndex]
		components[idx] = components[lastIndex]
		indexes[idx] = indexes[lastIndex]

		entities.removeLast()
		components.removeLast()
		indexes.removeLast()
	}
}
