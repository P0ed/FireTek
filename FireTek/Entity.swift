struct Entity {
	let id: Int
}

extension Entity: Hashable {

	var hashValue: Int {
		return id.hashValue
	}
}

func ==(lhs: Entity, rhs: Entity) -> Bool {
	return lhs.id == rhs.id
}

struct EntityMaker {

	var unusedID: Int = 0

	mutating func create() -> Entity {
		let entity = Entity(id: unusedID)
		unusedID += 1
		return entity
	}
}
