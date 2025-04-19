import SpriteKit

struct StarSystemData {

	struct Planet {
		var radius: Float
		var color: PlanetColor
		var orbit: Float
		var velocity: Float
		var angle: Float
	}

	enum PlanetColor {
		case red
		case green
		case blue
		case cyan
		case yellow
		case orange
	}

	var planets: [Planet]
}

struct PlanetComponent {
	var physics: ComponentIdx<PhysicsComponent>
	var orbit: Float
	var velocity: Float
	var angle: Float
}

extension StarSystemData.Planet {
	var position: CGPoint {
		CGPoint(x: CGFloat(orbit * cos(angle)), y: CGFloat(orbit * sin(angle)))
	}
}

extension PlanetComponent {
	var position: CGPoint {
		CGPoint(x: CGFloat(orbit * cos(angle)), y: CGFloat(orbit * sin(angle)))
	}
}
