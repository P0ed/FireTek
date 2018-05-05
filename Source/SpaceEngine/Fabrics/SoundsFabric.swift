import SpriteKit

enum SoundsFabric {

	static func preheat() {
		_ = [cannon, explosion, vehicleExplosion, crystalCollected]
	}

	static let crystalCollected: SKAction
		= .playSoundFileNamed("CrystalCollected.wav", waitForCompletion: false)

	static let cannon: SKAction
		= .playSoundFileNamed("Cannon0.wav", waitForCompletion: false)

	static let explosion: SKAction
		= .playSoundFileNamed("Boom1.wav", waitForCompletion: false)

	static let vehicleExplosion: SKAction
		= .playSoundFileNamed("Boom2.wav", waitForCompletion: false)
}
