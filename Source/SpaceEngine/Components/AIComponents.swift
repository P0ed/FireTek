import Fx

struct VehicleAIComponent {

	enum State {
		case move(Point)
		case hold(Point)
		case attack(Point)
		case patrol(Point, Point)
	}

	let vehicle: ComponentIdx<ShipComponent>
	var state: State
	var target: Entity?
}
