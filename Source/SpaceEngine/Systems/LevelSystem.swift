import Fx

final class LevelSystem {

	struct State {
		var player: Entity
		var game: GameState
	}

	@MutableProperty
	private(set) var state: State
	private let world: World
	private let level: SpaceLevel

	var restart = {}

	init(world: World, level: SpaceLevel) {
		self.world = world
		self.level = level
		state = .initialState(world: world, level: level)
	}

	func update() {
		if !world.entityManager.isAlive(state.player) {
			restart()
		}
	}
}

extension LevelSystem.State {

	static func initialState(world: World, level: SpaceLevel) -> LevelSystem.State {
		let game = GameState.make()
		let player = UnitFactory.createTank(world: world, ship: game.ship, position: level.spawnPosition, team: .blue)

		UnitFactory.createAIPlayer(world: world, position: Point(x: 0, y: 1500))
		UnitFactory.createAIPlayer(world: world, position: Point(x: 200, y: 1500))

		StarSystemFactory.createSystem(world: world, data: level.starSystem)

		return .init(
			player: player,
			game: game
		)
	}
}
