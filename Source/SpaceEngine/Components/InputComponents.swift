struct ShipInputComponent {
	var accelerate: Float
	var turnHull: Float
	var strafe: Float

	var primaryFire: Bool
	var secondaryFire: Bool
	var special: Bool

	static var empty: ShipInputComponent {
		return ShipInputComponent(
			accelerate: 0,
			turnHull: 0,
			strafe: 0,
			primaryFire: false,
			secondaryFire: false,
			special: false
		)
	}
}

struct VehicleInputComponent {
	var accelerate: Float
	var turnHull: Float
	var turnTurret: Float
	var fire: Bool

	static var empty: VehicleInputComponent {
		return VehicleInputComponent(
			accelerate: 0,
			turnHull: 0,
			turnTurret: 0,
			fire: false
		)
	}
}

struct TowerInputComponent {
	var turn: Float
	var fire: Bool
}
