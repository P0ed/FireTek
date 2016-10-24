import PowerCore
import Fx

struct VehicleAIComponent {

	enum State {
		case move(Point)
		case hold(Point)
		case attack(Point)
		case patrol(Point, Point)
	}

	let vehicle: Box<Int>
	var state: State
	var target: Entity?
}

struct TowerAIComponent {
	let tower: Box<Int>
	var target: Entity?
}
