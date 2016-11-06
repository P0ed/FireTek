import SpriteKit

final class HUDNode: SKNode {

	let playerArmor = HPNode()

	override init() {
		super.init()

		addChild(playerArmor)
	}

	required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	func layout(size: CGSize) {
//		guard let scene = scene else { return }

		playerArmor.layout(size: size)
		playerArmor.position = CGPoint(x: 0 - 300, y: 0 - 180)
	}
}

final class HPNode: SKNode {

	static let spacing: CGFloat = 1
	static let side: CGFloat = 4
	static let cellSize: CGSize = .square(side: side)
	static let cellColor = SKColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)

	let hpCell: SKSpriteNode
	let armorCells: [SKSpriteNode]

	override init() {
		hpCell = SKSpriteNode(color: HPNode.cellColor, size: .square(side: HPNode.side * 3 + HPNode.spacing * 2))
		armorCells = (0..<40).map { _ in SKSpriteNode(color: HPNode.cellColor, size: HPNode.cellSize) }

		super.init()

		hpCell.anchorPoint = .zero
		addChild(hpCell)

		armorCells.forEach { $0.anchorPoint = .zero }
		armorCells.forEach(addChild)
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
	}
}
