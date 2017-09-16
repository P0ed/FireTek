import SpriteKit

final class HUDMapNode: SKNode {

	let circle = SKShapeNode(circleOfRadius: 44)

	override init() {
		super.init()

		circle.strokeColor = .clear
		circle.fillColor = SKColor(white: 1, alpha: 0.1)
		addChild(circle)
	}
	
	required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
