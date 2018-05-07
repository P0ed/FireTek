import SpriteKit

protocol Routable: class {
	weak var router: Router? { get set }
	var rootScene: SKScene { get }
}

class Scene: SKScene, Routable {
	weak var router: Router?
	var rootScene: SKScene { return self }

//	override init(size: CGSize) {
//		super.init(size: size)
//		scaleMode = .aspectFit
//	}
}

final class Router {
	let view: SKView
	private(set) var stack: [Routable] = []

	init(view: SKView) {
		self.view = view
	}

	func push(_ routable: Routable) {
		stack.append(routable)
		routable.router = self

		view.presentScene(routable.rootScene)
	}

	func pop() {
		guard !stack.isEmpty else { return }

		let routable = stack.removeLast()
		routable.router = nil

		view.presentScene(stack.last?.rootScene)
	}
}
