import SpriteKit

final class HUDNode: SKNode {
	let playerHP = HPNode()
	let targetHP = HPNode()
	let targetShield = BarNode()
	let weapon1 = BarNode()
	let weapon2 = BarNode()
	let capacitor = BarNode()
	let shield = BarNode()
	let message = SKLabelNode()

	override init() {
		super.init()

		message.horizontalAlignmentMode = .right
		message.verticalAlignmentMode = .top
		message.fontSize = 8
		message.numberOfLines = 8
		message.fontName = "Menlo"

		capacitor.label.text = "CAP"
		weapon1.label.text = "PRM"
		weapon2.label.text = "SEC"

		[playerHP, targetHP, targetShield, weapon1, weapon2, capacitor, shield, message].forEach(addChild)
	}

	required init?(coder aDecoder: NSCoder) { fatalError() }

	func layout(size: CGSize) {
		let wh = size.width / 2
		let hh = size.height / 2
		playerHP.layout(size: size)
		targetHP.layout(size: size)
		targetShield.layout(size: size)
		weapon1.layout(size: size)
		weapon2.layout(size: size)
		capacitor.layout(size: size)
		shield.layout(size: size)

		playerHP.position = CGPoint(x: 4 - wh, y: 8 - hh)
		targetHP.position = CGPoint(x: 4 - wh, y: hh - 40)
		shield.position = CGPoint(x: 4 - wh, y: 49 - hh)
		targetShield.position = CGPoint(x: 4 - wh, y: hh - 50)

		let dx = wh - BarNode.size.width - 4
		let dy = 16 - hh
		weapon1.position = CGPoint(x: dx, y: dy)
		weapon2.position = CGPoint(x: dx, y: 14 + dy)
		capacitor.position = CGPoint(x: dx, y: 28 + dy)

		message.position = CGPoint(x: wh - 4, y: hh - 4)
	}
}
