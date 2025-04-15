import SpriteKit

final class HPNode: SKNode {

	static let spacing: CGFloat = 1
	static let side: CGFloat = 4
	static let cellSize: CGSize = .square(side: side)
	static let cellColor = SKColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 0.8)
	static let texture = { () -> SKTexture in
		let texture = SKTextureAtlas(named: "HUD").textureNamed("Armor")
		texture.filteringMode = .nearest
		return texture
	}()

	let hpCell: SKSpriteNode
	let armorCells: [SKSpriteNode]
	let label: SKLabelNode

	override init() {
		hpCell = SKSpriteNode(color: HPNode.cellColor, size: .square(side: HPNode.side * 3 + HPNode.spacing * 2))
		hpCell.texture = HPNode.texture

		armorCells = (0..<40).map { _ in
			let cell = SKSpriteNode(color: HPNode.cellColor, size: HPNode.cellSize)
			cell.texture = HPNode.texture
			return cell
		}

		label = SKLabelNode()

		super.init()

		hpCell.anchorPoint = .zero
		addChild(hpCell)

		armorCells.forEach { $0.anchorPoint = .zero }
		armorCells.forEach(addChild)

		label.horizontalAlignmentMode = .center
		label.verticalAlignmentMode = .center
		label.fontSize = 6
		label.fontName = "Menlo"
		addChild(label)
	}

	required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	func layout(size: CGSize) {

		let side = (HPNode.side + HPNode.spacing) * 7 - HPNode.spacing

		hpCell.position = CGPoint(
			x: (HPNode.side + HPNode.spacing) * 2,
			y: (HPNode.side + HPNode.spacing) * 3 - HPNode.spacing
		)

		for (index, cell) in armorCells.enumerated() {
			let position = HPComponent.convert(i: index)
			cell.position = CGPoint(
				x: CGFloat(position.x) * (HPNode.side + HPNode.spacing),
				y: side - CGFloat(position.y) * (HPNode.side + HPNode.spacing)
			)
		}

		label.position = hpCell.position + .init(x: 24, y: 48)
	}
}
