import SpriteKit

final class ParticleSystem {
	let camera: SKCameraNode
	let ref: WeakRef<PhysicsComponent>?

	init(camera: SKCameraNode, ref: WeakRef<PhysicsComponent>?) {
		self.camera = camera
		self.ref = ref
//
//		let textureNames: [String] = [
//			"skybox_right1.png",
//			"skybox_left2.png",
//			"skybox_top3.png",
//			"skybox_bottom4.png",
//			"skybox_front5.png",
//			"skybox_back6.png"
//		]
//		let textures = textureNames.map(SpriteFactory.space.textureNamed)
//		let tiles = textures.enumerated().map { idx, tx in
//			let sprite = SKSpriteNode(texture: tx)
//			sprite.position = CGPoint(x: Double(idx % 2) * 1024, y: Double(idx % 3) * 1024)
//			sprite.zPosition = -1000
//			return sprite
//		}
//		if let p = camera.parent { tiles.forEach(p.addChild) }


//		tile = SKTileMapNode(tileSet: tiles, columns: 2, rows: 3, tileSize: .square(side: 1024))
//		tile.zPosition = -1000
//		tile.fill(with: textures.first.map { SKTileGroup(tileDefinition: .init(texture: $0)) })

//		particles = SKEmitterNode(fileNamed: "Dust")
//		if let particles { camera.addChild(particles) }
//		particles?.particleLifetime = 2
	}

	func update() {
//		guard let particles, let phy = ref?.value else { return }
//		particles.particleSpeed = phy.warping ? 64 : phy.momentum.length * 12
//		particles.emissionAngle = (phy.warping ? phy.rotation.radians + .pi / 2 : phy.momentum.angle) - .pi
	}
}
