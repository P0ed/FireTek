import Fx

final class World {
	let entityManager: EntityManager
	let physics: Store<Physics>
	let shipRefs: Store<ShipRef>
	let ships: Store<Ship>
	let loot: Store<LootComponent>
	let crystals: Store<Crystal>
	let dead: Store<DeadComponent>
	let input: Store<Input>
	let vehicleAI: Store<VehicleAIComponent>
	let projectiles: Store<ProjectileComponent>
	let lifetime: Store<LifetimeComponent>
	let team: Store<Team>
	let planets: Store<PlanetComponent>

	init() {
		entityManager = EntityManager()
		physics = entityManager.makeStore()
		shipRefs = entityManager.makeStore()
		ships = entityManager.makeStore()
		input = entityManager.makeStore()
		vehicleAI = entityManager.makeStore()
		team = entityManager.makeStore()
		projectiles = entityManager.makeStore()
		lifetime = entityManager.makeStore()
		loot = entityManager.makeStore()
		dead = entityManager.makeStore()
		crystals = entityManager.makeStore()
		planets = entityManager.makeStore()
	}
}
