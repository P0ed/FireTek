import Fx

final class Core {
	private var unusedStoreID: StoreID = 0
	let entityManager = EntityManager()

	func makeStore<Component>() -> Store<Component> {
		let store = Store<Component>(id: unusedStoreID, entityManager: entityManager)
		unusedStoreID += 1
		return store
	}
}

typealias StoreID = UInt16

final class Store<C> {

	unowned var entityManager: EntityManager

	private let id: StoreID
	private var entities: [Entity] = []
	private var components: [C] = []
	private var indexes: [IO<Int>] = []
	private var map: [Entity: Int] = [:]

	let newComponents: Signal<Int>
	private let newComponentsPipe: (Int) -> ()

	let removedComponents: Signal<(Entity, C)>
	private let removedComponentsPipe: ((Entity, C)) -> ()

	init(id: StoreID, entityManager: EntityManager) {
		self.id = id
		self.entityManager = entityManager

		(newComponents, newComponentsPipe) = Signal.pipe()
		(removedComponents, removedComponentsPipe) = Signal.pipe()
	}

	func sharedIndexAt(_ index: Int) -> ComponentIdx<C> {
		return ComponentIdx(box: indexes[index].readonly)
	}

	func indexOf(_ entity: Entity) -> Int? {
		return entityManager.isAlive(entity) ? map[entity] : nil
	}

	func entityAt(_ index: Int) -> Entity {
		return entities[index]
	}

	subscript(index: Int) -> C {
		get {
			return components[index]
		}
		set(component) {
			components[index] = component
		}
	}

	subscript(index: ComponentIdx<C>) -> C {
		get { return self[index.box.value] }
		set { self[index.box.value] = newValue }
	}

	func weakRefAt(_ index: Int) -> WeakRef<C> {
		return WeakRef(store: self, entity: entities[index], index: sharedIndexAt(index))
	}

	func refAt(_ index: Int) -> Ref<C> {
		return Ref(store: self, entity: entities[index], index: index)
	}

	@discardableResult
	func add(component: C, to entity: Entity) -> Int {
		let index = components.count
		let sharedIndex = IO(copy: index)

		entities.append(entity)
		components.append(component)
		indexes.append(sharedIndex)
		map[entity] = index

		entityManager.setRemoveHandle(entity: entity, storeID: id) { [weak self] in
			self?.removeAt(sharedIndex.value)
		}

		newComponentsPipe(index)

		return index
	}

	func set(component: C, to entity: Entity) {
		guard entityManager.isAlive(entity) else { return }

		if let index = map[entity] {
			self[index] = component
		} else {
			add(component: component, to: entity)
		}
	}

	func removeAt(_ index: Int) {
		let entity = entities[index]
		let component = components[index]
		let lastInt = entities.endIndex - 1
		let lastEntity = entities[lastInt]

		entities[index] = entities[lastInt]
		entities.removeLast()

		components[index] = components[lastInt]
		components.removeLast()

		let sharedIndex = indexes[lastInt]
		sharedIndex.value = index
		indexes[index] = sharedIndex
		indexes.removeLast()

		map[lastEntity] = index
		map[entity] = nil

		entityManager.setRemoveHandle(entity: entity, storeID: id, handle: nil)

		removedComponentsPipe((entity, component))
	}

	var indices: CountableRange<Int> {
		return 0..<entities.count
	}
}

extension Store: Sequence {
	typealias Iterator = Array<C>.Iterator

	func makeIterator() -> Store.Iterator {
		return components.makeIterator()
	}
}

extension Store {

	func removeComponents(where f: (Entity, C) -> Bool) {
		var index = 0
		while index < components.count {
			if f(entities[index], components[index]) {
				removeAt(index)
			} else {
				index += 1
			}
		}
	}

	func removeEntities(where f: (Entity, C) -> Bool) {
		var index = 0
		while index < components.count {
			let entity = entities[index]
			if f(entity, components[index]) {
				removeAt(index)
				entityManager.removeEntity(entity)
			} else {
				index += 1
			}
		}
	}
}

struct ComponentIdx<C> {
	let box: Readonly<Int>
}

struct WeakRef<A> {
	unowned let store: Store<A>
	let entity: Entity
	let index: ComponentIdx<A>

	var value: A? {
		get {
			if store.entityManager.isAlive(entity) {
				return store[index]
			} else {
				return nil
			}
		}
		nonmutating set {
			if store.entityManager.isAlive(entity) {
				if let value = newValue {
					store[index] = value
				} else {
					store.removeAt(index.box.value)
				}
			}
		}
	}

	var ref: Ref<A>? {
		if store.entityManager.isAlive(entity) {
			return store.refAt(index.box.value)
		}
		return nil
	}
}

struct Ref<A> {
	unowned let store: Store<A>
	let entity: Entity
	let index: Int

	var value: A {
		get { return store[index] }
		nonmutating set { return store[index] = newValue }
	}

	func delete() {
		store.removeAt(index)
	}

	var weakRef: WeakRef<A> {
		return store.weakRefAt(index)
	}
}
