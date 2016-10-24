import PowerCore
import Fx
import SpriteKit
import Runes

struct AISystem {

	let world: World
	var currentTick: Int

	init(world: World) {
		self.world = world
		currentTick = 0
	}

	mutating func update() {
		if currentTick == 0 {
			updateVehicles()
		}

		currentTick = (currentTick + 1) % 8
	}

	private func updateVehicles() {
		let ai = world.vehicleAI
		ai.enumerated().forEach { index, ai in
			let vehicle = world.vehicles[ai.vehicle.value]
			world.vehicleInput[vehicle.input.value] = {

				var ai = ai
				var input = .empty as VehicleInputComponent
				if ai.target == nil {
					ai.target = { world.team.entityAt($0) } <^> world.team.find{ (team: Team) in team == .blue }
				}

				if let target = ai.target, let targetSprite = world.sprites.indexOf(target) {
					let sprite = world.sprites[vehicle.sprite.value].sprite
					let position = sprite.position
					let targetPosition = world.sprites[targetSprite].sprite.position
					let distance = position.distance(to: targetPosition)

					if distance > 120 {
						let toTarget = (targetPosition - position).asVector

						let angle = sprite.orientation.angle(with: toTarget)
						let (sa, ca) = (sin(angle), cos(angle))

						if abs(sa) > 0.1 || ca < 0 {
							input.turnHull = sa < 0 ? 1 : -1
						} else {
							input.turnHull = 0
						}

						if cos(angle) > 0.1 {
							input.accelerate = Float(ca)
						}
					}


				}
				
				world.vehicleAI[index] = ai

				return input
			}()
		}
	}
}
