import PowerCore
import SpriteKit

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

	init(_ model: Model) {
		self.model = model
		world = World()
		spriteSpawnSystem = SpriteSpawnSystem(scene: model.scene(), store: world.sprites)
		physicsSystem = PhysicsSystem(world: world)
		levelSystem = LevelSystem(world: world, level: Level())
		inputSystem = InputSystem(world: world, player: levelSystem.state.value.player, inputController: model.inputController)
	}

	func simulate() {
		inputSystem.update()
		physicsSystem.update()
		levelSystem.update()
	}
}
