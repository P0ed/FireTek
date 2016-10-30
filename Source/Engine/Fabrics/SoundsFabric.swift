import SpriteKit

enum SoundsFabric {

	static func preload() {
		_ = [cannon(), explosion(), vehicleExplosion()]
	}

	static func cannon() -> SKAction {
		return .playSoundFileNamed("Cannon-0.wav", waitForCompletion: false)
	}

	static func explosion() -> SKAction {
		return .playSoundFileNamed("Boom-1.wav", waitForCompletion: false)
	}

	static func vehicleExplosion() -> SKAction {
		return .playSoundFileNamed("Boom-2.wav", waitForCompletion: false)
	}
}
