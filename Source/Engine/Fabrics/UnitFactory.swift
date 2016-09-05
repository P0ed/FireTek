import PowerCore
import Fx
import SpriteKit

enum UnitFactory {

	static func createPlayer(world world: World, position: Point, team: Team) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createTankSprite(entity, at: position)
		let hp = HPComponent(hp: 80)
		let physics = vehiclePhysics(sprite.sprite)

		let weapon = Weapon(
			type: .Shell,
			damage: 6,
			velocity: 300,
			cooldown: 2.5,
			perShotCooldown: 0.4,
			maxAmmo: 80,
			roundsPerShot: 3
		)

		let stats = VehicleStats(speed: 20, weapon: weapon)

		let vehicle = VehicleComponent(
			sprite: world.sprites.sharedIndexAt § world.sprites.add(sprite, to: entity),
			physics: world.physics.sharedIndexAt § world.physics.add(physics, to: entity),
			hp: world.hp.sharedIndexAt § world.hp.add(hp, to: entity),
			input: world.vehicleInput.sharedIndexAt § world.vehicleInput.add(.empty, to: entity),
			stats: world.vehicleStats.sharedIndexAt § world.vehicleStats.add(stats, to: entity)
		)
		world.vehicles.add(vehicle, to: entity)
		world.team.add(team, to: entity)

		return entity
	}

	static func createAIPlayer(world world: World, position: Point) -> Entity {
		let entity = createPlayer(world: world, position: position, team: .Red)
		let vehicle = world.vehicles.sharedIndexAt § world.vehicles.indexOf(entity)!

		let ai = VehicleAIComponent(vehicle: vehicle, state: .Hold(Point(x: 0, y: 0)), target: nil)
		world.vehicleAI.add(ai, to: entity)

		return entity
	}

	static func vehiclePhysics(sprite: SKSpriteNode) -> PhysicsComponent {
		let body = SKPhysicsBody(rectangleOfSize: CGSize(width: 32, height: 64))
		body.dynamic = true
		body.mass = 40
		sprite.physicsBody = body
		return PhysicsComponent(body: body)
	}

	static func createBuilding(world world: World, position: Point) -> Entity {
		let entity = world.entityManager.create()
		let sprite = SpriteFactory.createBuildingSprite(entity)
		let hp = HPComponent(hp: 20)

		let building = BuildingComponent(
			sprite: world.sprites.sharedIndexAt § world.sprites.add(sprite, to: entity),
			hp: world.hp.sharedIndexAt § world.hp.add(hp, to: entity)
		)

		world.buildings.add(building, to: entity)

		return entity
	}
}
