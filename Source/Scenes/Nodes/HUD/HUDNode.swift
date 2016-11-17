import SpriteKit
import Runes

final class HUDNode: SKNode {

	let playerHP = HPNode()
	let targetHP = HPNode()
	let weapon1 = WeaponNode()
	let weapon2 = WeaponNode()

	override init() {
		super.init()

		_ = addChild <^> [playerHP, targetHP, weapon1, weapon2]
	}

	required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	func layout(size: CGSize) {
		playerHP.layout(size: size)
		targetHP.layout(size: size)
		playerHP.position = CGPoint(x: 0 - 300, y: 0 - 180)
		targetHP.position = CGPoint(x: 0 - 300, y: 0 + 140)

		let weaponSize = CGSize(width: size.width / 2 - 16, height: 16)
		weapon1.layout(size: weaponSize)
		weapon2.layout(size: weaponSize)
		weapon1.position = CGPoint(x: 0, y: 16 - size.height / 2)
		weapon2.position = CGPoint(x: 0, y: 16 + 16 - size.height / 2)
	}
}
