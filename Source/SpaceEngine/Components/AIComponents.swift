struct VehicleAIComponent {

	enum State {
		case move(CGPoint)
		case hold(CGPoint)
		case attack(CGPoint)
		case patrol(CGPoint, CGPoint)
	}

	let vehicle: ComponentIdx<ShipRef>
	var state: State
	var target: Entity?
}
