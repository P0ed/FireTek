import SpriteKit

enum SpriteFactory {

	static let effects = SKTextureAtlas(named: "Effects")
	static let space = SKTextureAtlas(named: "Space")

	static func createShipSprite(_ entity: Entity, at position: Point) -> SpriteComponent {
		let texture = SKTexture(imageNamed: "Intruder")
		texture.filteringMode = .nearest

		let spriteNode = SKSpriteNode(texture: texture)
		spriteNode.position = position.cgPoint
		spriteNode.entity = entity

		return SpriteComponent(sprite: spriteNode)
	}

	static func createTankSprite(_ entity: Entity, at position: Point) -> SpriteComponent {
		let texture = SKTexture(imageNamed: "Tank")
		texture.filteringMode = .nearest

		let spriteNode = SKSpriteNode(texture: texture)
		spriteNode.setScale(2)
		spriteNode.position = position.cgPoint
		spriteNode.entity = entity

		return SpriteComponent(sprite: spriteNode)
	}

	static func createBuildingSprite(_ entity: Entity, at position: Point) -> SpriteComponent {
		let color = SKColor(red: 0.2, green: 0.3, blue: 0.2, alpha: 1)
		let spriteNode = SKSpriteNode(color: color, size: CGSize(width: 32, height: 32))
		spriteNode.position = position.cgPoint
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

	static func createStar(entity: Entity, data: StarSystemData.Star) -> SKSpriteNode {
		let node = SKSpriteNode(texture: space.textureNamed("Planet"))
		node.size = CGSize(width: CGFloat(data.radius * 2), height: CGFloat(data.radius * 2))
		node.color = data.color.color
		node.colorBlendFactor = 0.5
		node.entity = entity
		return node
	}

	static func createPlanet(entity: Entity, data: StarSystemData.Planet) -> SKSpriteNode {
		let node = SKSpriteNode(texture: space.textureNamed("Planet"))
		node.size = CGSize(width: CGFloat(data.radius * 2), height: CGFloat(data.radius * 2))
		node.color = data.color.color
		node.colorBlendFactor = 0.5
		node.entity = entity
		return node
	}
}

extension StarSystemData.StarColor {
	var color: SKColor {
		switch self {
		case .red:		return SKColor(hex: 0xee0000)
		case .blue:		return SKColor(hex: 0x0000ee)
		}
	}
}

extension StarSystemData.PlanetColor {
	var color: SKColor {
		switch self {
		case .yellow:	return SKColor(hex: 0xeeee00)
		case .orange:	return SKColor(hex: 0xff7700)
		case .green:	return SKColor(hex: 0x00cc00)
		case .cyan:		return SKColor(hex: 0x00ccaa)
		}
	}
}
