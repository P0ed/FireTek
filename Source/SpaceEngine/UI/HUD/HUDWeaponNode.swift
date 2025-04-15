import SpriteKit

final class WeaponNode: SKNode {

	static let cooldownSize = CGSize(width: 32, height: 8)

	let cooldownNode: CooldownNode
	let roundsLabel: SKLabelNode

	override init() {
		cooldownNode = CooldownNode()
		roundsLabel = SKLabelNode()
		roundsLabel.horizontalAlignmentMode = .right
		roundsLabel.verticalAlignmentMode = .center
		roundsLabel.fontSize = 6
		roundsLabel.fontName = "Menlo"

		super.init()

		[cooldownNode, roundsLabel].forEach(addChild)
	}

	required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	func layout(size: CGSize) {
		cooldownNode.position = CGPoint(
			x: size.width - WeaponNode.cooldownSize.width,
			y: (size.height - WeaponNode.cooldownSize.height) / 2
		)
		roundsLabel.position = CGPoint(
			x: size.width - WeaponNode.cooldownSize.width - 2,
			y: size.height / 2
		)
	}
}

final class CooldownNode: SKNode {

	let background: SKSpriteNode
	let progress: SKSpriteNode

	override init() {
		background = SKSpriteNode(color: SKColor(white: 0.5, alpha: 0.5), size: WeaponNode.cooldownSize)
		progress = SKSpriteNode(color: SKColor(white: 0.9, alpha: 0.9), size: WeaponNode.cooldownSize)

		background.anchorPoint = .zero
		progress.anchorPoint = .zero

		super.init()

		[background, progress].forEach(addChild)
	}
	
	required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
