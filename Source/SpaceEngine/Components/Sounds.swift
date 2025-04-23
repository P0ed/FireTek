import SpriteKit

enum Sound: UInt8, CaseIterable {
	case warp, impulse
	case blaster, torpedo
	case blasterHit, torpedoHit
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
	"warp.wav", "CH1.wav",
	"CH0.wav", "CH3.wav",
	"CH2.wav", "CH2.wav",
	"Boom2.wav",
	"CrystalCollected.wav"
]

extension SKAction {
	static func play(_ sound: Sound) -> SKAction {
		Sound.sounds[sound] ?? sound.action
	}
}
