import Fx

final class LevelSystem {
	let player: Entity
	private let entityManager: EntityManager

	var restart = {}

	init(world: World, state: GameState) {
		entityManager = world.entityManager

		let starSystem = StarSystemData.generate()
		let spawn = starSystem.planets.last!.position + .init(x: 28, y: 28)
		player = UnitFactory.createTank(world: world, ship: state.ship, position: spawn, team: .blue)

//		UnitFactory.createAIPlayer(world: world, position: CGPoint(x: 0, y: 1500))
		UnitFactory.createAIPlayer(world: world, position: CGPoint(x: 200, y: 1500))
		UnitFactory.createAIPlayer(world: world, position: CGPoint(x: -200, y: 1500))

		StarSystemFactory.createSystem(world: world, data: starSystem)
	}

	func update() {
		if !entityManager.isAlive(player) {
			restart()
		}
	}
}
