import Fx
import PowerCore

struct LevelSystem {

	struct State {
		let player: Entity
	}

	private var mutableState: MutableProperty<State>
	private let world: World
	private let level: Level

	let state: Property<State>

	init(world: World, level: Level) {
		self.world = world
		self.level = level
		mutableState = MutableProperty(.initialState(world: world, level: level))
		state = mutableState.map(id)
	}

	mutating func update() {
		if world.vehicles.indexOf(state.value.player) == nil {
			/// Game over
		}
	}
}

extension LevelSystem.State {

	static func initialState(world world: World, level: Level) -> LevelSystem.State {
		let player = UnitFactory.createPlayer(world: world, position: level.spawnPosition, team: .Blue)
		UnitFactory.createAIPlayer(world: world, position: Point(x: 180, y: 40))
		UnitFactory.createAIPlayer(world: world, position: Point(x: 40, y: 180))

		return LevelSystem.State(
			player: player
		)
	}
}
