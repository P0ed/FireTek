final class Engine {

	private var unusedStoreID: StoreID = 0
	let entityManager: EntityManager

	init() {
		entityManager = EntityManager()
	}

	func createStore<Component>() -> Store<Component> {
		let store = Store<Component>(id: unusedStoreID, entityManager: entityManager)
		unusedStoreID += 1
		return store
	}
}
