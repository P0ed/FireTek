import Fx

final class World {
	let entityManager: EntityManager
	let sprites: Store<SpriteComponent>
	let physics: Store<PhysicsComponent>

	let shipRefs: Store<ShipRef>

	let shipStats: Store<Ship>
	let targets: Store<TargetComponent>

	let loot: Store<LootComponent>
	let crystals: Store<Crystal>
	let dead: Store<DeadComponent>

	let vehicleInput: Store<VehicleInputComponent>
	let towerInput: Store<TowerInputComponent>

	let vehicleAI: Store<VehicleAIComponent>

	let projectiles: Store<ProjectileComponent>
	let lifetime: Store<LifetimeComponent>

	let team: Store<Team>

	let planets: Store<PlanetComponent>
	let mapItems: Store<MapItem>

	init() {
		entityManager = EntityManager()
		sprites = entityManager.makeStore()
		physics = entityManager.makeStore()

		shipRefs = entityManager.makeStore()

		shipStats = entityManager.makeStore()
		targets = entityManager.makeStore()

		vehicleInput = entityManager.makeStore()
		towerInput = entityManager.makeStore()

		vehicleAI = entityManager.makeStore()

		team = entityManager.makeStore()
		projectiles = entityManager.makeStore()
		lifetime = entityManager.makeStore()
		loot = entityManager.makeStore()
		dead = entityManager.makeStore()
		crystals = entityManager.makeStore()

		planets = entityManager.makeStore()
		mapItems = entityManager.makeStore()
	}
}
