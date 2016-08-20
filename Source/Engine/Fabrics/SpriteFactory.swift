import SpriteKit

enum SpriteFactory {

	static func createTankSprite(position: Point) -> SpriteComponent {
		let texture = SKTexture(imageNamed: "Tank")
		texture.filteringMode = .Nearest

		let spriteNode = SKSpriteNode(texture: texture)
		spriteNode.setScale(2)
		spriteNode.position = position.cgPoint

		return SpriteComponent(sprite: spriteNode)
	}

	static func createBuildingSprite() -> SpriteComponent {
		let color = SKColor(red: 0.2, green: 0.3, blue: 0.2, alpha: 1)
		let spriteNode = SKSpriteNode(color: color, size: CGSize(width: 32, height: 32))
		return SpriteComponent(sprite: spriteNode)
	}
}
