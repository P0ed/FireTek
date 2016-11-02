import SpriteKit
import PowerCore

enum SpriteFactory {

	static let effects = SKTextureAtlas(named: "Effects")

	static func createTankSprite(_ entity: Entity, at position: Point) -> SpriteComponent {
		let texture = SKTexture(imageNamed: "Tank")
		texture.filteringMode = .nearest

		let spriteNode = SKSpriteNode(texture: texture)
		spriteNode.setScale(2)
		spriteNode.position = position.cgPoint
		spriteNode.entity = entity

		spriteNode.shadowCastBitMask = 0x1
		spriteNode.lightingBitMask = 0x1

		return SpriteComponent(sprite: spriteNode)
	}

	static func createBuildingSprite(_ entity: Entity) -> SpriteComponent {
		let color = SKColor(red: 0.2, green: 0.3, blue: 0.2, alpha: 1)
		let spriteNode = SKSpriteNode(color: color, size: CGSize(width: 32, height: 32))
		spriteNode.entity = entity
		return SpriteComponent(sprite: spriteNode)
	}

	static func createProjectileSprite(_ entity: Entity, type: ProjectileType) -> SpriteComponent {
		let spriteNode = SKSpriteNode(texture: effects.textureNamed("shell"))
		spriteNode.entity = entity
		return SpriteComponent(sprite: spriteNode)
	}

	static func createCrystal(entity: Entity, at position: CGPoint, crystal: Crystal) -> SpriteComponent {
		let node = SKSpriteNode(texture: effects.textureNamed("crystal"))
		node.setScale(0.3)
		node.entity = entity
		node.position = position
		return SpriteComponent(sprite: node)
	}
}

// MARK: Textures
extension SpriteFactory {

	static func shellExplosionTextures() -> [SKTexture] {
		return (0...7).map { index in
			effects.textureNamed("shell-explosion-\(index)")
		}
	}

	static func vehiceExplosionTextures() -> [SKTexture] {
		return (0...6).map { index in
			effects.textureNamed("vehicle-explosion-\(index)")
		}
	}
}
