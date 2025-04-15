import Fx

final class World {
	let entityManager: EntityManager
	let sprites: Store<SpriteComponent>
	let physics: Store<PhysicsComponent>

	let ships: Store<ShipComponent>
	let buildings: Store<BuildingComponent>

	let hp: Store<HPComponent>
	let shipStats: Store<ShipStats>
	let primaryWpn: Store<WeaponComponent>
	let secondaryWpn: Store<WeaponComponent>
	let targets: Store<TargetComponent>

	let loot: Store<LootComponent>
	let crystals: Store<Crystal>
	let dead: Store<DeadComponent>

	let vehicleInput: Store<VehicleInputComponent>
	let towerInput: Store<TowerInputComponent>

	let vehicleAI: Store<VehicleAIComponent>
	let towerAI: Store<TowerAIComponent>

	let projectiles: Store<ProjectileComponent>
	let lifetime: Store<LifetimeComponent>
	let owners: Store<OwnerComponent>

	let team: Store<Team>

	let planets: Store<PlanetComponent>
	let mapItems: Store<MapItem>

	init() {
		entityManager = EntityManager()
		sprites = entityManager.makeStore()
		physics = entityManager.makeStore()

		ships = entityManager.makeStore()
		buildings = entityManager.makeStore()

		hp = entityManager.makeStore()
		shipStats = entityManager.makeStore()
		primaryWpn = entityManager.makeStore()
		secondaryWpn = entityManager.makeStore()
		targets = entityManager.makeStore()

		vehicleInput = entityManager.makeStore()
		towerInput = entityManager.makeStore()

		vehicleAI = entityManager.makeStore()
		towerAI = entityManager.makeStore()

		team = entityManager.makeStore()
		projectiles = entityManager.makeStore()
		lifetime = entityManager.makeStore()
		loot = entityManager.makeStore()
		dead = entityManager.makeStore()
		crystals = entityManager.makeStore()
		owners = entityManager.makeStore()

		planets = entityManager.makeStore()
		mapItems = entityManager.makeStore()
	}
}
