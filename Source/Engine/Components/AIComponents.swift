import PowerCore
import Fx

struct VehicleAIComponent {

	enum State {
		case Move(Point)
		case Hold(Point)
		case Attack(Point)
		case Patrol(Point, Point)
	}

	let vehicle: Box<Int>
	var state: State
	var target: Entity?
}

struct TowerAIComponent {
	let tower: Box<Int>
	var target: Entity?
}
