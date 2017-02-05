import PowerCore
import SpriteKit

struct StarSystemData {

	struct Star {
		let radius: Float
		let color: StarColor
	}

	enum StarColor {
		case red
		case blue
	}

	struct Planet {
		let radius: Float
		let color: PlanetColor
		let orbit: Float
		let velocity: Float
		let position: Float
	}

	enum PlanetColor {
		case green
		case cyan
		case yellow
		case orange
	}

	let star: Star
	let planets: [Planet]
}

struct PlanetComponent {
	let sprite: SKSpriteNode
	let orbit: Float
	let velocity: Float
	var position: Float
}
