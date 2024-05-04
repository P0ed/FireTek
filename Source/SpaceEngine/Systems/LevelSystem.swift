import Fx

struct LevelSystem {

	struct State {
		let player: Entity
	}

	private let mutableState: MutableProperty<State>
	private let world: World
	private let level: SpaceLevel

	let state: Property<State>

	init(world: World, level: SpaceLevel) {
		self.world = world
		self.level = level
		mutableState = MutableProperty(.initialState(world: world, level: level))
		state = mutableState.map(id)
	}

	mutating func update() {
		if !world.entityManager.isAlive(state.value.player) {
			/// Game over
		}
	}
}

extension LevelSystem.State {

	static func initialState(world: World, level: SpaceLevel) -> LevelSystem.State {
		let player = UnitFactory.createTank(world: world, position: level.spawnPosition, team: .blue)
		UnitFactory.createAIPlayer(world: world, position: Point(x: 220, y: 40))
		UnitFactory.createAIPlayer(world: world, position: Point(x: 40, y: 220))

//		let buildings: [Point] = [
//			Point(x: 140, y: 120),
//			Point(x: 220, y: 140),
//			Point(x: 280, y: 120),
//			Point(x: 360, y: 140),
//			Point(x: 140, y: 320),
//			Point(x: 220, y: 340),
//			Point(x: 280, y: 320),
//			Point(x: 360, y: 340)
//		]
//
//		buildings.forEach {
//			UnitFactory.createBuilding(world: world, position: $0)
//		}

		StarSystemFactory.createSystem(world: world, data: level.starSystem)

		return LevelSystem.State(
			player: player
		)
	}
}
