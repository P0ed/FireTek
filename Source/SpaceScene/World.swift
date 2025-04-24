import Fx

final class World {
	let entityManager: EntityManager
	let input: Store<Input>
	let physics: Store<Physics>
	let planets: Store<PlanetComponent>
	let ships: Store<Ship>
	let shipRefs: Store<ShipRef>
	let lifetime: Store<LifetimeComponent>
	let crystals: Store<Crystal>
	let projectiles: Store<ProjectileComponent>
	let vehicleAI: Store<VehicleAIComponent>
	let team: Store<Team>
	let loot: Store<LootComponent>
	let dead: Store<DeadComponent>

	private(set) var state: GameState
	private(set) var players: Array4<Entity>

	init(initialState: GameState) {
		entityManager = EntityManager()
		input = entityManager.makeStore()
		physics = entityManager.makeStore()
		planets = entityManager.makeStore()
		ships = entityManager.makeStore()
		shipRefs = entityManager.makeStore()
		lifetime = entityManager.makeStore()
		crystals = entityManager.makeStore()
		projectiles = entityManager.makeStore()
		vehicleAI = entityManager.makeStore()
		team = entityManager.makeStore()
		loot = entityManager.makeStore()
		dead = entityManager.makeStore()

		state = initialState
		players = .init([entityManager.create()])

		loadState()
	}
}

extension World {

	private func loadState() {
		let starSystem = StarSystemData()
		let spawn = starSystem.planets[3].position + .init(x: 27, y: 22)

		let units = unitFactory
		units.makeTank(entity: players[0], ship: state.ship, position: spawn, category: [.blu, .player])

		units.createSystem(data: starSystem)
	}

	func spawnEnemies() {
		let spawn = planets.indices.last.map { planets[$0].position } ?? .zero
		unitFactory.makeAIPlayer(entity: entityManager.create(), position: spawn + .init(x: 27, y: 22))
		unitFactory.makeAIPlayer(entity: entityManager.create(), position: spawn - .init(x: 27, y: 22))
	}
}
