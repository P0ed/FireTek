import PowerCore
import SpriteKit
import Fx

final class Engine {

	struct Model {
		let scene: () -> GameScene
		let inputController: InputController
	}

	static let timeStep = 1.0 / 60.0 as CFTimeInterval

	private let model: Model
	let world: World

	private var levelSystem: LevelSystem
	private let spriteSpawnSystem: SpriteSpawnSystem
	private let inputSystem: InputSystem
	private let physicsSystem: PhysicsSystem
	private let collisionsSystem: CollisionsSystem
	private let damageSystem: DamageSystem
	private let targetSystem: TargetSystem
	private var aiSystem: AISystem
	private let cameraSystem: CameraSystem
	private var weaponSystem: WeaponSystem
	private let projectileSystem: ProjectileSystem
	private let lifetimeSystem: LifetimeSystem
	private let lootSystem: LootSystem
	private let hudSystem: HUDSystem
	private let planetarySystem: PlanetarySystem

	init(_ model: Model) {
		self.model = model
		let world = World()
		self.world = world

		spriteSpawnSystem = SpriteSpawnSystem(scene: model.scene(), store: world.sprites)
		physicsSystem = PhysicsSystem(world: world)
		collisionsSystem = CollisionsSystem(scene: model.scene())

		weaponSystem = WeaponSystem(world: world)
		damageSystem = DamageSystem(world: world)
		targetSystem = TargetSystem(targets: world.targets)
		projectileSystem = ProjectileSystem(world: world, collisionsSystem: collisionsSystem, damageSystem: damageSystem)

		levelSystem = LevelSystem(world: world, level: .default)
		inputSystem = InputSystem(world: world, player: levelSystem.state.value.player, inputController: model.inputController)
		aiSystem = AISystem(world: world)

		lifetimeSystem = LifetimeSystem(world: world)

		lootSystem = LootSystem(world: world, collisionsSystem: collisionsSystem)

		cameraSystem = CameraSystem(player: world.sprites[0].sprite, camera: model.scene().camera!)
		cameraSystem.update()

		hudSystem = HUDSystem(world: world, player: levelSystem.state.value.player, hudNode: model.scene().hud)

		planetarySystem = PlanetarySystem(planets: world.planets)
	}

	func simulate() {
		inputSystem.update()
		physicsSystem.update()
		planetarySystem.update()

		weaponSystem.update()
		targetSystem.update()

		projectileSystem.update()

		levelSystem.update()
//		aiSystem.update()

		hudSystem.update()

		lootSystem.update()
		lifetimeSystem.update()
	}

	func didFinishUpdate() {
		cameraSystem.update()
	}
}
