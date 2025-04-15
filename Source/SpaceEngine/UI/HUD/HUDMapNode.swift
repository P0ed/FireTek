import SpriteKit

final class HUDMapNode: SKNode {
	private let circle = SKShapeNode(circleOfRadius: 32)

	override init() {
		super.init()

		circle.strokeColor = .clear
		circle.fillColor = SKColor(white: 1, alpha: 0.08)
		addChild(circle)
	}
	
	required init?(coder aDecoder: NSCoder) { fatalError() }
}
