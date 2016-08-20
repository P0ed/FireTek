import PowerCore
import SpriteKit

final class Engine {

	struct Model {
		let scene: () -> SKScene
	}

	private let model: Model
	let world: World

	init(_ model: Model) {
		self.model = model
		world = World()
	}

	func simulate() {
		
	}
}

final class World {
	let entityManager: EntityManager
	let sprites: Store<SpriteComponent>

	let vehicles: Store<VehicleComponent>
	let buildings: Store<BuildingComponent>

	let hp: Store<HPComponent>

	let towerInput: Store<TowerInputComponent>
	let vehicleInput: Store<VehicleInputComponent>

	let towerAI: Store<TowerAIComponent>
	let vehicleAI: Store<VehicleAIComponent>

	init() {
		let core = PowerCore.World()
		entityManager = core.entityManager
		sprites = core.createStore()
		vehicles = core.createStore()
		buildings = core.createStore()
		hp = core.createStore()
		towerInput = core.createStore()
		vehicleInput = core.createStore()
		towerAI = core.createStore()
		vehicleAI = core.createStore()
	}
}
