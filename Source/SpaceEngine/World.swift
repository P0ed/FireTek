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
	let crystals: Store<CrystalComponent>
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
		let core = Core()
		entityManager = core.entityManager
		sprites = core.makeStore()
		physics = core.makeStore()

		ships = core.makeStore()
		buildings = core.makeStore()

		hp = core.makeStore()
		shipStats = core.makeStore()
		primaryWpn = core.makeStore()
		secondaryWpn = core.makeStore()
		targets = core.makeStore()

		vehicleInput = core.makeStore()
		towerInput = core.makeStore()

		vehicleAI = core.makeStore()
		towerAI = core.makeStore()

		team = core.makeStore()
		projectiles = core.makeStore()
		lifetime = core.makeStore()
		loot = core.makeStore()
		dead = core.makeStore()
		crystals = core.makeStore()
		owners = core.makeStore()

		planets = core.makeStore()
		mapItems = core.makeStore()
	}
}
