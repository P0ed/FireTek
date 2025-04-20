import SpriteKit

enum SpriteFactory {
	static let effects = SKTextureAtlas(named: "VFX")

	static func createShipSprite(_ entity: Entity) -> SKNode {
		let texture = SKTexture(imageNamed: "Intruder")
		texture.filteringMode = .nearest

		let spriteNode = SKSpriteNode(texture: texture)
		spriteNode.entity = entity
		spriteNode.zPosition = 1

		return spriteNode
	}

	static func createProjectileSprite(_ entity: Entity, type: WeaponType) -> SKNode {
		let spriteNode = SKSpriteNode(texture: effects.textureNamed(type.textureName))
		spriteNode.entity = entity
		return spriteNode
	}

	static func createCrystal(entity: Entity, crystal: Crystal) -> SKNode {
		let node = SKSpriteNode(texture: effects.textureNamed("crystal"))
		node.entity = entity
		return node
	}
}

extension WeaponType {
	var textureName: String {
		switch self {
		case .torpedo: "torpedo"
		default: "shell"
		}
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
		let node = SKSpriteNode(texture: effects.textureNamed("Planet"))
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
		case .red:		SKColor(hex: 0xAA0000)
		case .green:	SKColor(hex: 0x00AA00)
		case .blue:		SKColor(hex: 0x0000AA)
		case .yellow:	SKColor(hex: 0xCCCC00)
		case .orange:	SKColor(hex: 0xCC7700)
		case .cyan:		SKColor(hex: 0x00AA99)
		case .magenta: 	SKColor(hex: 0xEE00DD)
		}
	}
}
