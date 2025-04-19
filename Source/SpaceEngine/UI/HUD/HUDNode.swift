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
	let weapon1 = BarNode(alignment: .right, text: "PRM")
	let weapon2 = BarNode(alignment: .right, text: "SEC")
	let capacitor = BarNode(alignment: .right, text: "CAP")
	let impulse = BarNode(alignment: .right, text: "IMP")
	let message = MessageNode()

	override init() {
		super.init()
		[
			targetFront, targetSide, targetCore, targetShield,
			front, side, core, shield,
			weapon1, weapon2, capacitor, impulse,
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
		let dyu = hh - 72
		let dyl = 72 - hh
		let dy = BarNode.size.height + 4

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

		impulse.position = CGPoint(x: dx, y: dyl)
		capacitor.position = CGPoint(x: dx, y: dyl - dy)
		weapon1.position = CGPoint(x: dx, y: dyl - dy * 2)
		weapon2.position = CGPoint(x: dx, y: dyl - dy * 3)

		message.position = CGPoint(x: wh - 4, y: hh - 4)
	}
}

private func MessageNode() -> SKLabelNode {
	let message = SKLabelNode()
	message.horizontalAlignmentMode = .right
	message.verticalAlignmentMode = .top
	message.fontSize = 8
	message.numberOfLines = 8
	message.fontName = "Menlo"
	return message
}
