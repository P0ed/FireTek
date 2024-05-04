struct VehicleInputComponent {
	var accelerate: Float = 0
	var turnHull: Float = 0
	var turnTurret: Float = 0

	var primary: Bool = false
	var secondary: Bool = false

	static let empty = VehicleInputComponent()
}

struct TowerInputComponent {
	var turn: Float
	var fire: Bool
}
