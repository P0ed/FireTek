import SpriteKit

final class HUDNode: SKNode {
	let targetFront = BarNode(alignment: .left, text: "FRNT")
	let targetSide = BarNode(alignment: .left, text: "SIDE")
	let targetCore = BarNode(alignment: .left, text: "CORE")
	let targetShield = BarNode(alignment: .left, text: "SHLD")

	let front = BarNode(alignment: .left, text: "FRNT")
	let side = BarNode(alignment: .left, text: "SIDE")
	let core = BarNode(alignment: .left, text: "CORE")
	let shield = BarNode(alignment: .left, text: "SHLD")

	let crystals = CrystalsNode()
	let impulse = BarNode(alignment: .right, text: "IMP")
	let capacitor = BarNode(alignment: .right, text: "CAP")
	let weapon1 = BarNode(alignment: .right, text: "CAN")
	let weapon2 = BarNode(alignment: .right, text: "TOR")
	let message = MessageNode()

	override init() {
		super.init()
		[
			targetFront, targetSide, targetCore, targetShield,
			front, side, core, shield,
			weapon1, weapon2, capacitor, impulse, crystals,
			message
		]
		.forEach(addChild)
	}

	required init?(coder aDecoder: NSCoder) { fatalError() }

	func layout(size: CGSize) {
		let wh = size.width / 2
		let hh = size.height / 2
		let dx = wh - BarNode.size.width - 6
		let dxl = 6 - wh
		let dyl = 72 - hh
		let dy = BarNode.size.height + 4
		let dyu = hh - 72 + 2 * dy

		targetFront.layout(size: size)
		targetSide.layout(size: size)
		targetCore.layout(size: size)
		targetShield.layout(size: size)

		weapon1.layout(size: size)
		weapon2.layout(size: size)
		capacitor.layout(size: size)
		impulse.layout(size: size)

		front.layout(size: size)
		side.layout(size: size)
		core.layout(size: size)
		shield.layout(size: size)

		targetCore.position = CGPoint(x: dxl, y: dyu)
		targetSide.position = CGPoint(x: dxl, y: dyu - dy)
		targetFront.position = CGPoint(x: dxl, y: dyu - dy * 2)
		targetShield.position = CGPoint(x: dxl, y: dyu - dy * 3)

		shield.position = CGPoint(x: dxl, y: dyl)
		front.position = CGPoint(x: dxl, y: dyl - dy)
		side.position = CGPoint(x: dxl, y: dyl - dy * 2)
		core.position = CGPoint(x: dxl, y: dyl - dy * 3)

		crystals.position = CGPoint(x: dx, y: dyl + dy)
		impulse.position = CGPoint(x: dx, y: dyl)
		capacitor.position = CGPoint(x: dx, y: dyl - dy)
		weapon1.position = CGPoint(x: dx, y: dyl - dy * 2)
		weapon2.position = CGPoint(x: dx, y: dyl - dy * 3)

		message.position = CGPoint(x: wh - 4, y: hh - 4)
	}
}

final class BarNode: SKNode {
	static let size = CGSize(width: 96, height: 16)

	let background: SKSpriteNode
	let progress: SKSpriteNode
	let label: SKLabelNode
	let alignment: SKLabelHorizontalAlignmentMode

	init(alignment: SKLabelHorizontalAlignmentMode, text: String) {
		self.alignment = alignment
		background = SKSpriteNode(color: SKColor(white: 0.3, alpha: 0.3), size: Self.size)
		progress = SKSpriteNode(color: SKColor(white: 0.8, alpha: 0.8), size: Self.size)
		label = LabelNode(text: text)
		label.horizontalAlignmentMode = alignment
		label.verticalAlignmentMode = .center

		background.anchorPoint = .zero
		progress.anchorPoint = .zero

		super.init()

		[background, progress, label].forEach(addChild)
	}

	required init?(coder aDecoder: NSCoder) { fatalError() }

	func layout(size: CGSize) {
		label.position = CGPoint(
			x: alignment == .right ? -4 : Self.size.width + 4,
			y: Self.size.height / 2
		)
	}
}

func LabelNode(text: String? = nil) -> SKLabelNode {
	let label = SKLabelNode()
	label.fontSize = 7
	label.fontName = "Menlo"
	label.text = text
	return label
}

private func MessageNode() -> SKLabelNode {
	let message = LabelNode()
	message.horizontalAlignmentMode = .right
	message.verticalAlignmentMode = .top
	message.numberOfLines = 8
	message.fontSize = 10
	message.preferredMaxLayoutWidth = 192
	return message
}

final class CrystalsNode: SKNode {

	var crystals: Array4<Crystal> = [] {
		didSet {
			guard crystals != oldValue else { return }
			sprites.enumerated().forEach { i, s in
				let cnt = crystals.count
				s.alpha = i < cnt ? 0.7 : 0.1
				s.color = i < cnt ? crystals[i].color : .gray
			}
		}
	}

	private let sprites: Quad<SKSpriteNode>

	override init() {
		sprites = .init(
			SKSpriteNode(color: .red, size: .square(side: 14)),
			SKSpriteNode(color: .red, size: .square(side: 14)),
			SKSpriteNode(color: .red, size: .square(side: 14)),
			SKSpriteNode(color: .red, size: .square(side: 14))
		)
		super.init()

		let dx = 24 as CGFloat
		sprites.enumerated().forEach { i, e in
			e.position = CGPoint(x: dx * CGFloat(i) + 12, y: 12)
			e.zRotation = .pi / 4
			e.color = .gray
			e.alpha = 0.1
		}
		sprites.forEach(addChild)
	}

	required init?(coder aDecoder: NSCoder) { fatalError() }
}

extension Crystal {

	var color: SKColor {
		switch self {
		case .red: .red
		case .amber: .orange
		case .yellow: .yellow
		case .cyan: .cyan
		case .blue: .blue
		case .violet: .magenta
		}
	}
}
