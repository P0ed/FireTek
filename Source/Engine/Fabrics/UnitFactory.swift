import PowerCore
import Fx
import SpriteKit

enum UnitFactory {

	static func createPlayer(world world: World, position: Point) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createTankSprite(position)
		let hp = HPComponent(maxHP: 100, currentHP: 100)
		let physics = vehiclePhysics(sprite.sprite)

		let vehicle = VehicleComponent(
			sprite: world.sprites.sharedIndexAt § world.sprites.add(sprite, to: entity),
			physics: world.physics.sharedIndexAt § world.physics.add(physics, to: entity),
			hp: world.hp.sharedIndexAt § world.hp.add(hp, to: entity),
			input: world.vehicleInput.sharedIndexAt § world.vehicleInput.add(.empty, to: entity)
		)
		world.vehicles.add(vehicle, to: entity)

		return entity
	}

	static func createAIPlayer(world world: World, position: Point) -> Entity {
		let entity = createPlayer(world: world, position: position)
		let vehicle = world.vehicles.sharedIndexAt § world.vehicles.indexOf(entity)!

		let ai = VehicleAIComponent(vehicle: vehicle, state: .Hold(Point(x: 0, y: 0)), target: nil)
		world.vehicleAI.add(ai, to: entity)

		return entity
	}

	static func vehiclePhysics(sprite: SKSpriteNode) -> PhysicsComponent {
		let body = SKPhysicsBody(rectangleOfSize: CGSize(width: 32, height: 64))
		body.dynamic = true
		body.mass = 40
		return PhysicsComponent(body: body)
	}

	static func createBuilding(world world: World, position: Point) -> Entity {
		let entity = world.entityManager.create()
		let sprite = SpriteFactory.createBuildingSprite()
		let hp = HPComponent(maxHP: 20, currentHP: 20)

		let building = BuildingComponent(
			sprite: world.sprites.sharedIndexAt § world.sprites.add(sprite, to: entity),
			hp: world.hp.sharedIndexAt § world.hp.add(hp, to: entity)
		)

		world.buildings.add(building, to: entity)

		return entity
	}
}
