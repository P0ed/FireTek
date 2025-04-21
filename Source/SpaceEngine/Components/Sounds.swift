import SpriteKit

enum Sound: UInt8, CaseIterable {
	case warp, impulse
	case blaster, torpedoe
	case blasterHit, torpedoeHit
	case explosion
	case crystalCollected
}

extension Sound {
	static let sounds: [Sound: SKAction] = .init(uniqueKeysWithValues: allCases.map { s in
		(s, s.action)
	})

	var action: SKAction {
		.playSoundFileNamed(soundsMap[Int(self.rawValue)], waitForCompletion: false)
	}
}

private let soundsMap: [String] = [
	"warp.vaw", "Boom0.wav",
	"Cannon0.wav", "Cannon0.wav",
	"Boom1.wav", "Boom1.wav",
	"Boom2.wav",
	"CrystalCollected.wav"
]

extension SKAction {
	static func play(_ sound: Sound) -> SKAction {
		Sound.sounds[sound] ?? sound.action
	}
}
