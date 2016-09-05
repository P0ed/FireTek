import SpriteKit
import PowerCore

enum SpriteFactory {

	static func createTankSprite(entity: Entity, at position: Point) -> SpriteComponent {
		let texture = SKTexture(imageNamed: "Tank")
		texture.filteringMode = .Nearest

		let spriteNode = SKSpriteNode(texture: texture)
		spriteNode.setScale(2)
		spriteNode.position = position.cgPoint
		spriteNode.entity = entity

		return SpriteComponent(sprite: spriteNode)
	}

	static func createBuildingSprite(entity: Entity) -> SpriteComponent {
		let color = SKColor(red: 0.2, green: 0.3, blue: 0.2, alpha: 1)
		let spriteNode = SKSpriteNode(color: color, size: CGSize(width: 32, height: 32))
		spriteNode.entity = entity
		return SpriteComponent(sprite: spriteNode)
	}

	static func createProjectileSprite(entity: Entity, type: ProjectileType) -> SpriteComponent {
		let color = SKColor(red: 0.7, green: 0.6, blue: 0.56, alpha: 1)
		let spriteNode = SKSpriteNode(color: color, size: CGSize(width: 4, height: 4))
		spriteNode.entity = entity
		return SpriteComponent(sprite: spriteNode)
	}
}
