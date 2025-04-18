import SpriteKit

final class BarNode: SKNode {
	static let size = CGSize(width: 44, height: 5.7)

	let background: SKSpriteNode
	let progress: SKSpriteNode
	let label: SKLabelNode

	override init() {
		background = SKSpriteNode(color: SKColor(white: 0.44, alpha: 0.55), size: Self.size)
		progress = SKSpriteNode(color: SKColor(white: 0.87, alpha: 0.87), size: Self.size)
		label = SKLabelNode()
		label.horizontalAlignmentMode = .right
		label.verticalAlignmentMode = .center
		label.fontSize = 6
		label.fontName = "Menlo"

		background.anchorPoint = .zero
		progress.anchorPoint = .zero

		super.init()

		[background, progress, label].forEach(addChild)
	}
	
	required init?(coder aDecoder: NSCoder) { fatalError() }

	func layout(size: CGSize) {
		label.position = CGPoint(
			x: -2,
			y: Self.size.height / 2
		)
	}
}
