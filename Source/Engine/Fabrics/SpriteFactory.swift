import SpriteKit
import PowerCore

enum SpriteFactory {

	static func createTankSprite(_ entity: Entity, at position: Point) -> SpriteComponent {
		let texture = SKTexture(imageNamed: "Tank")
		texture.filteringMode = .nearest

		let spriteNode = SKSpriteNode(texture: texture)
		spriteNode.setScale(2)
		spriteNode.position = position.cgPoint
		spriteNode.entity = entity

		return SpriteComponent(sprite: spriteNode)
	}

	static func createBuildingSprite(_ entity: Entity) -> SpriteComponent {
		let color = SKColor(red: 0.2, green: 0.3, blue: 0.2, alpha: 1)
		let spriteNode = SKSpriteNode(color: color, size: CGSize(width: 32, height: 32))
		spriteNode.entity = entity
		return SpriteComponent(sprite: spriteNode)
	}

	static func createProjectileSprite(_ entity: Entity, type: ProjectileType) -> SpriteComponent {
		let color = SKColor(red: 0.7, green: 0.6, blue: 0.3, alpha: 1)
		let spriteNode = SKSpriteNode(color: color, size: CGSize(width: 4, height: 4))
		spriteNode.entity = entity
		return SpriteComponent(sprite: spriteNode)
	}
}
