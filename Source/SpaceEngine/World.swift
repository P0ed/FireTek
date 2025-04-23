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

	private(set) var players: Array4<Entity>

	init() {
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

		players = .init([entityManager.create()])
	}
}

extension World {

	func load(state: GameState) {
		let starSystem = StarSystemData()
		let spawn = starSystem.planets[3].position + .init(x: 27, y: 22)
		let mkEntity = entityManager.create

		let units = unitFactory
		units.makeTank(entity: players[0], ship: state.ship, position: spawn, category: [.blu, .player])
		units.makeAIPlayer(entity: mkEntity(), position: CGPoint(x: 0, y: 1500))
		units.makeAIPlayer(entity: mkEntity(), position: CGPoint(x: 200, y: 1500))
		units.makeAIPlayer(entity: mkEntity(), position: CGPoint(x: -200, y: 1500))

		units.createSystem(data: starSystem)
	}
}
