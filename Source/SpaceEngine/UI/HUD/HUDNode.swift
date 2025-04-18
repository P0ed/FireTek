import SpriteKit

final class HUDNode: SKNode {

	let playerHP = HPNode()
	let targetHP = HPNode()
	let weapon1 = BarNode()
	let weapon2 = BarNode()
	let capacitor = BarNode()
	let shield = BarNode()

	let map = HUDMapNode()

	override init() {
		super.init()

		[playerHP, targetHP, weapon1, weapon2, capacitor, shield, map].forEach(addChild)
	}

	required init?(coder aDecoder: NSCoder) { fatalError() }

	func layout(size: CGSize) {
		playerHP.layout(size: size)
		targetHP.layout(size: size)
		playerHP.position = CGPoint(x: 0 - 300, y: 0 - 180)
		targetHP.position = CGPoint(x: 0 - 300, y: 0 + 140)

		weapon1.layout(size: size)
		weapon2.layout(size: size)
		capacitor.layout(size: size)
		shield.layout(size: size)
		let dx = size.width / 2 - BarNode.size.width - 8
		let dy = 16 - size.height / 2
		weapon1.position = CGPoint(x: dx, y: dy)
		weapon2.position = CGPoint(x: dx, y: 7 + dy)
		capacitor.position = CGPoint(x: dx, y: 14 + dy)
		shield.position = CGPoint(x: dx, y: 21 + dy)

		map.position = CGPoint(x: size.width / 2 - 44 - 16, y: size.height / 2 - 44 - 16)
	}
}
