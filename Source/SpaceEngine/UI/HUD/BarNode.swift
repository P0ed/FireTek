import SpriteKit

final class BarNode: SKNode {
	static let size = CGSize(width: 88, height: 16)

	let background: SKSpriteNode
	let progress: SKSpriteNode
	let label: SKLabelNode
	let alignment: SKLabelHorizontalAlignmentMode

	init(alignment: SKLabelHorizontalAlignmentMode, text: String) {
		self.alignment = alignment
		background = SKSpriteNode(color: SKColor(white: 0.3, alpha: 0.3), size: Self.size)
		progress = SKSpriteNode(color: SKColor(white: 0.8, alpha: 0.8), size: Self.size)
		label = SKLabelNode()
		label.horizontalAlignmentMode = alignment
		label.verticalAlignmentMode = .center
		label.fontSize = 8
		label.fontName = "Menlo"
		label.text = text

		background.anchorPoint = .zero
		progress.anchorPoint = .zero

		super.init()

		[background, progress, label].forEach(addChild)
	}

	required init?(coder aDecoder: NSCoder) { fatalError() }

	func layout(size: CGSize) {
		label.position = CGPoint(
			x: alignment == .right ? -3 : Self.size.width + 3,
			y: Self.size.height / 2
		)
	}
}
