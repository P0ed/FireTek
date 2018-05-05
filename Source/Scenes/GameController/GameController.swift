import SpriteKit

final class GameController: Routable {

	weak var router: Router?
	var rootScene: SKScene

	private var state: GameState

	init(state: GameState) {
		self.state = state
		rootScene = SpaceScene.create()
	}
}
