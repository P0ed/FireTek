import PowerCore
import Fx
import SpriteKit

enum UnitFactory {

	static func createPlayer(world: World) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createTankSprite()
		let hp = HPComponent(maxHP: 100, currentHP: 100)

		let vehicle = VehicleComponent(
			sprite: world.sprites.sharedIndexAt § world.sprites.add(sprite, to: entity),
			hp: world.hp.sharedIndexAt § world.hp.add(hp, to: entity),
			input: world.vehicleInput.sharedIndexAt § world.vehicleInput.add(.empty, to: entity)
		)
		world.vehicles.add(vehicle, to: entity)

		return entity
	}

	static func createAIPlayer(world: World) -> Entity {
		let entity = createPlayer(world)
		let vehicle = world.vehicles.sharedIndexAt § world.vehicles.indexOf(entity)!

		let ai = VehicleAIComponent(vehicle: vehicle, state: .Hold(Point(x: 0, y: 0)), target: nil)
		world.vehicleAI.add(ai, to: entity)

		return entity
	}
}
