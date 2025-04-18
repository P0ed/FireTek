import Fx
import SpriteKit

struct AISystem {

	let world: World
	var currentTick: Int

	init(world: World) {
		self.world = world
		currentTick = 0
	}

	mutating func update() {
		if currentTick & 0x7 == 0 {
			updateVehicles()
		}

		currentTick &+= 1
	}

	private func updateVehicles() {
		let ai = world.vehicleAI
		ai.enumerated().forEach { index, ai in
			let vehicle = world.shipRefs[ai.vehicle.box.value]
			world.vehicleInput[vehicle.input.box.value] = {

				var ai = ai as VehicleAIComponent
				var input = .empty as VehicleInputComponent
				if ai.target == nil {
					ai.target = world.team.first({ $0 == .blue })?.entity
				}

				if let target = ai.target, let targetSprite = world.sprites.indexOf(target) {
					let sprite = world.sprites[vehicle.sprite.box.value].sprite
					let position = sprite.position
					let targetPosition = world.sprites[targetSprite].sprite.position
					let distance = position.distance(to: targetPosition)

					let toTarget = (targetPosition - position).vector

					let angle = sprite.orientation.angle(with: toTarget)
					let (sa, ca) = (sin(angle), cos(angle))

					if abs(sa) > 0.1 || ca < 0 {
						input.dhat = sa > 0 ? .left : .right
						input.primary = false
						input.secondary = false
					} else {
						input.dhat = .null
						input.primary = distance < 400
						input.secondary = distance < 800
					}

					if cos(angle) > 0.1 && distance > 180 {
						if distance > 500 {
							input.warp = ca > 0.5
							input.impulse = false
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
