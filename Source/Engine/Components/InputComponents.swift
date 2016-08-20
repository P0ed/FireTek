struct VehicleInputComponent {
	var accelerate: Float
	var turnHull: Float
	var turnTurret: Float

	var primaryFire: Bool
	var secondaryFire: Bool
	var special: Bool

	static var empty: VehicleInputComponent {
		return VehicleInputComponent(
			accelerate: 0,
			turnHull: 0,
			turnTurret: 0,
			primaryFire: false,
			secondaryFire: false,
			special: false
		)
	}
}

struct TowerInputComponent {
	var turn: Float
	var fire: Bool
}
