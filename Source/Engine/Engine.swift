import PowerCore
import SpriteKit

final class Engine {

	struct Model {
		let scene: () -> SKScene
	}

	static let timeStep = 1.0 / 60.0 as CFTimeInterval

	private let model: Model
	let world: World

	var levelSystem: LevelSystem
	let spriteSpawnSystem: SpriteSpawnSystem

	init(_ model: Model) {
		self.model = model
		world = World()
		spriteSpawnSystem = SpriteSpawnSystem(scene: model.scene(), store: world.sprites)
		levelSystem = LevelSystem(world: world, level: Level())
	}

	func simulate() {
		levelSystem.update()
	}
}
