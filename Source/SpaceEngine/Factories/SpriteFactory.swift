import SpriteKit

enum SpriteFactory {
	static let effects = SKTextureAtlas(named: "Effects")
	static let space = SKTextureAtlas(named: "Space")

	static func createShipSprite(_ entity: Entity, at position: CGPoint) -> SpriteComponent {
		let texture = SKTexture(imageNamed: "Intruder")
		texture.filteringMode = .nearest

		let spriteNode = SKSpriteNode(texture: texture)
		spriteNode.position = position
		spriteNode.entity = entity
		spriteNode.setScale(0.66)
		spriteNode.zPosition = 1

		return SpriteComponent(sprite: spriteNode)
	}

	static func createProjectileSprite(_ entity: Entity, type: WeaponType) -> SpriteComponent {
		let spriteNode = SKSpriteNode(texture: effects.textureNamed("shell"))
		spriteNode.entity = entity
		spriteNode.setScale(0.33)
		return SpriteComponent(sprite: spriteNode)
	}

	static func createCrystal(entity: Entity, at position: CGPoint, crystal: Crystal) -> SpriteComponent {
		let node = SKSpriteNode(texture: effects.textureNamed("crystal"))
		node.setScale(0.25)
		node.entity = entity
		node.position = position
		node.entity = entity
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

// MARK: Stars & Planets
extension SpriteFactory {

	static func createPlanet(entity: Entity, data: StarSystemData.Planet) -> SKSpriteNode {
		let node = SKSpriteNode(texture: space.textureNamed("Planet"))
		node.size = CGSize(width: CGFloat(data.radius * 2), height: CGFloat(data.radius * 2))
		node.color = data.color.color
		node.colorBlendFactor = 0.5
		node.zPosition = -1
		node.entity = entity

		return node
	}
}

extension StarSystemData.PlanetColor {
	var color: SKColor {
		switch self {
		case .red:		return SKColor(hex: 0xAA0000)
		case .green:	return SKColor(hex: 0x00AA00)
		case .blue:		return SKColor(hex: 0x0000AA)
		case .yellow:	return SKColor(hex: 0xCCCC00)
		case .orange:	return SKColor(hex: 0xCC7700)
		case .cyan:		return SKColor(hex: 0x00AA99)
		}
	}
}
