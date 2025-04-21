import Fx
import SpriteKit

struct AISystem {

	let world: World

	init(world: World) {
		self.world = world
	}

	mutating func update(tick: Int) {
		if tick & 0x7 == 0 {
			updateVehicles()
		}
	}

	private func updateVehicles() {
		let ai = world.vehicleAI
		ai.enumerated().forEach { index, ai in
			let ref = world.shipRefs[ai.vehicle.box.value]
			world.input[ref.input.box.value] = {

				let ship = world.ships[ref.ship]
				var ai = ai as VehicleAIComponent
				var input = .empty as Input
				if ai.target == nil {
					ai.target = world.physics.first({ $0.category.contains(.blu) })?.entity
				}

				if let target = ai.target, let targetPhysics = world.physics.indexOf(target) {
					let physics = world.physics[ref.physics]
					let tPhysics = world.physics[targetPhysics]
					let energy = ship.reactor.normalized

					let vector = (tPhysics.position - physics.position).vector
					let distance = vector.length

					let angle = physics.rotation.vector.angle(with: vector)
					let (sa, ca) = (sin(angle), cos(angle))

					if abs(sa) > 0.1 || ca < 0 {
						input.dpad = sa > 0 ? .left : .right
						input.primary = false
						input.secondary = false
					} else {
						input.dpad = .null
						input.primary = distance < 400
						input.secondary = distance < 800 && energy > 0.6
					}

					if cos(angle) > 0.1 && distance > 180 {
						if distance > 500 {
							input.warp = ca > 0.5 && energy > 0.4
							input.impulse = !input.warp
						} else {
							input.impulse = ca > 0.5
							input.warp = false
						}
					} else {
						input.impulse = false
						input.warp = false
					}
				}

				world.vehicleAI[index] = ai

				return input
			}()
		}
	}
}
