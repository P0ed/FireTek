import PowerCore
import SpriteKit
import Fx

final class Engine {

	struct Model {
		let scene: () -> SKScene
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
	private var aiSystem: AISystem
	private let cameraSystem: CameraSystem
	private var weaponSystem: WeaponSystem
	private let projectileSystem: ProjectileSystem

	init(_ model: Model) {
		self.model = model
		let world = World()
		self.world = world
		spriteSpawnSystem = SpriteSpawnSystem(scene: model.scene(), store: world.sprites)
		physicsSystem = PhysicsSystem(world: world)
		collisionsSystem = CollisionsSystem(scene: model.scene())
		weaponSystem = WeaponSystem(world: world)
		projectileSystem = ProjectileSystem(world: world, collisionsSystem: collisionsSystem)

		levelSystem = LevelSystem(world: world, level: Level())
		inputSystem = InputSystem(world: world, player: levelSystem.state.value.player, inputController: model.inputController)
		aiSystem = AISystem(world: world)

		cameraSystem = CameraSystem(player: world.sprites[0].sprite, camera: model.scene().camera!)
		cameraSystem.update()
	}

	func simulate() {
		inputSystem.update()
		physicsSystem.update()
		weaponSystem.update()
		projectileSystem.update()
		levelSystem.update()
		aiSystem.update()
		cameraSystem.update()
	}
}
