import SpriteKit

enum SoundsFactory {

	static func preheat() {
		_ = [cannon, explosion, vehicleExplosion, crystalCollected, impulse, warp]
	}

	static let crystalCollected: SKAction = sound("CrystalCollected.wav")
	static let cannon: SKAction = sound("Cannon0.wav")
	static let impulse: SKAction = sound("Boom0.wav")
	static let explosion: SKAction = sound("Boom1.wav")
	static let vehicleExplosion: SKAction = sound("Boom2.wav")
	static let warp: SKAction = sound("warp.wav")
}

private func sound(_ name: String) -> SKAction {
	.playSoundFileNamed(name, waitForCompletion: false)
}
