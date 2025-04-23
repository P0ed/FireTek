import SpriteKit

struct StarSystemData {

	struct Planet {
		var radius: CGFloat
		var color: PlanetColor
		var orbit: CGFloat
		var velocity: CGFloat
		var angle: CGFloat
		var hasShop: Bool = false
	}

	enum PlanetColor {
		case red
		case green
		case blue
		case cyan
		case yellow
		case orange
		case magenta
	}

	var name: String
	var planets: [Planet]
}

struct PlanetComponent {
	var physics: ComponentIdx<Physics>
	var orbit: CGFloat
	var velocity: CGFloat
	var angle: CGFloat
	var hasShop: Bool
	var orbiting: Array4<Entity>
}

extension StarSystemData.Planet {
	var position: CGPoint {
		.init(x: CGFloat(orbit * cos(angle)), y: CGFloat(orbit * sin(angle)))
	}
}

extension PlanetComponent {
	var position: CGPoint {
		CGPoint(x: CGFloat(orbit * cos(angle)), y: CGFloat(orbit * sin(angle)))
	}
}
