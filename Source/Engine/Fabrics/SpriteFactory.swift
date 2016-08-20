import SpriteKit

enum SpriteFactory {

	static func createTankSprite() -> SpriteComponent {
		let texture = SKTexture(imageNamed: "Tank")
		texture.filteringMode = .Nearest

		let spriteNode = SKSpriteNode(texture: texture)
		spriteNode.setScale(2)

		return SpriteComponent(sprite: spriteNode)
	}
}