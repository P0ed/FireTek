import PowerCore
import Fx

final class World {
	let entityManager: EntityManager
	let sprites: Store<SpriteComponent>
	let physics: Store<PhysicsComponent>

	let ships: Store<ShipComponent>
	let vehicles: Store<VehicleComponent>
	let buildings: Store<BuildingComponent>

	let hp: Store<HPComponent>
	let vehicleStats: Store<VehicleStats>
	let primaryWpn: Store<WeaponComponent>
	let secondaryWpn: Store<WeaponComponent>
	let targets: Store<TargetComponent>

	let loot: Store<LootComponent>
	let crystals: Store<CrystalComponent>
	let dead: Store<DeadComponent>

	let shipInput: Store<ShipInputComponent>
	let vehicleInput: Store<VehicleInputComponent>
	let towerInput: Store<TowerInputComponent>

	let towerAI: Store<TowerAIComponent>
	let vehicleAI: Store<VehicleAIComponent>

	let projectiles: Store<ProjectileComponent>
	let lifetime: Store<LifetimeComponent>
	let owners: Store<OwnerComponent>

	let team: Store<Team>

	let planets: Store<PlanetComponent>
	let mapItems: Store<MapItem>

	init() {
		let core = PowerCore.World()
		entityManager = core.entityManager
		sprites = core.createStore()
		physics = core.createStore()

		ships = core.createStore()
		vehicles = core.createStore()
		buildings = core.createStore()

		hp = core.createStore()
		vehicleStats = core.createStore()
		primaryWpn = core.createStore()
		secondaryWpn = core.createStore()
		targets = core.createStore()

		shipInput = core.createStore()
		vehicleInput = core.createStore()
		towerInput = core.createStore()

		towerAI = core.createStore()
		vehicleAI = core.createStore()

		team = core.createStore()
		projectiles = core.createStore()
		lifetime = core.createStore()
		loot = core.createStore()
		dead = core.createStore()
		crystals = core.createStore()
		owners = core.createStore()

		planets = core.createStore()
		mapItems = core.createStore()
	}
}
