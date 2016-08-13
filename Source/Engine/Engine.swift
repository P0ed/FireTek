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
