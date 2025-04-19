import Fx

final class World {
	let entityManager: EntityManager
	let sprites: Store<SpriteComponent>
	let physics: Store<PhysicsComponent>
	let shipRefs: Store<ShipRef>
	let ships: Store<Ship>
	let targets: Store<TargetComponent>
	let loot: Store<LootComponent>
	let crystals: Store<Crystal>
	let dead: Store<DeadComponent>
	let input: Store<InputComponent>
	let vehicleAI: Store<VehicleAIComponent>
	let projectiles: Store<ProjectileComponent>
	let lifetime: Store<LifetimeComponent>
	let team: Store<Team>
	let planets: Store<PlanetComponent>

	init() {
		entityManager = EntityManager()
		sprites = entityManager.makeStore()
		physics = entityManager.makeStore()
		shipRefs = entityManager.makeStore()
		ships = entityManager.makeStore()
		targets = entityManager.makeStore()
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
