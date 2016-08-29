import Fx

struct VehicleComponent {
	let sprite: Box<Int>
	let physics: Box<Int>
	let hp: Box<Int>
	let input: Box<Int>

	let stats: Stats
}

extension VehicleComponent {
	struct Stats {
		let speed: Float
	}
}

struct TowerComponent {
	let sprite: Box<Int>
	let hp: Box<Int>
	let input: Box<Int>
}

struct BuildingComponent {
	let sprite: Box<Int>
	let hp: Box<Int>
}

enum Team {
	case Blue
	case Red
}
