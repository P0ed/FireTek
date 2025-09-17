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
	let crystalBank: Store<Array4<Crystal>>
	let projectiles: Store<ProjectileComponent>
	let vehicleAI: Store<VehicleAIComponent>
	let team: Store<Team>
	let dead: Store<DeadComponent>

	private(set) var players: Array4<Entity>
	private var states: Array4<PlayerState>

	subscript(_ idx: Int) -> PlayerState {
		get { states[idx] }
		set { states[idx] = newValue }
	}

	init(initialState: PlayerState) {
		entityManager = EntityManager()
		input = entityManager.makeStore()
		physics = entityManager.makeStore()
		planets = entityManager.makeStore()
		ships = entityManager.makeStore()
		shipRefs = entityManager.makeStore()
		lifetime = entityManager.makeStore()
		crystals = entityManager.makeStore()
		crystalBank = entityManager.makeStore()
		projectiles = entityManager.makeStore()
		vehicleAI = entityManager.makeStore()
		team = entityManager.makeStore()
		dead = entityManager.makeStore()

		players = [entityManager.create()]
		states = [initialState]

		loadState()
	}
}

extension World {

	private func loadState() {
		let starSystem = StarSystemData()
		let spawn = starSystem.planets[3].position + .init(x: 27, y: 22)

		let units = unitFactory
		units.makeTank(
			entity: players[0],
			ship: states[0].ship,
			position: spawn,
			category: [.blu, .player]
		)

		units.createSystem(data: starSystem)
	}

	func spawnEnemies() {
		let spawn = planets.indices.last.map { planets[$0].position } ?? .zero
		unitFactory.makeAIPlayer(entity: entityManager.create(), position: spawn + .init(x: 27, y: 22))
		unitFactory.makeAIPlayer(entity: entityManager.create(), position: spawn - .init(x: 27, y: 22))
	}
}
