import PowerCore
import Fx
import SpriteKit

enum UnitFactory {

	@discardableResult
	static func createPlayer(world: World, position: Point, team: Team) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createTankSprite(entity, at: position)
		let hp = HPComponent(hp: 80)
		let physics = vehiclePhysics(sprite.sprite)

		let weapon = Weapon(
			type: .shell,
			damage: 6,
			velocity: 300,
			cooldown: 1.2,
			perShotCooldown: 0.15,
			maxAmmo: 80,
			roundsPerShot: 3
		)

		let stats = VehicleStats(speed: 28, weapon: weapon)

		let vehicle = VehicleComponent(
			sprite: world.sprites.sharedIndexAt § world.sprites.add(component: sprite, to: entity),
			physics: world.physics.sharedIndexAt § world.physics.add(component: physics, to: entity),
			hp: world.hp.sharedIndexAt § world.hp.add(component: hp, to: entity),
			input: world.vehicleInput.sharedIndexAt § world.vehicleInput.add(component: .empty, to: entity),
			stats: world.vehicleStats.sharedIndexAt § world.vehicleStats.add(component: stats, to: entity)
		)
		world.vehicles.add(component: vehicle, to: entity)
		world.team.add(component: team, to: entity)

		return entity
	}

	@discardableResult
	static func createAIPlayer(world: World, position: Point) -> Entity {
		let entity = createPlayer(world: world, position: position, team: .red)
		let vehicle = world.vehicles.sharedIndexAt § world.vehicles.indexOf(entity)!

		let ai = VehicleAIComponent(vehicle: vehicle, state: .hold(Point(x: 0, y: 0)), target: nil)
		world.vehicleAI.add(component: ai, to: entity)

		return entity
	}

	static func vehiclePhysics(_ sprite: SKSpriteNode) -> PhysicsComponent {
		let body = SKPhysicsBody(rectangleOf: CGSize(width: 32, height: 64))
		body.isDynamic = true
		body.mass = 40
		sprite.physicsBody = body
		return PhysicsComponent(body: body)
	}

	@discardableResult
	static func createBuilding(world: World, position: Point) -> Entity {
		let entity = world.entityManager.create()
		let sprite = SpriteFactory.createBuildingSprite(entity)
		let hp = HPComponent(hp: 20)

		let building = BuildingComponent(
			sprite: world.sprites.sharedIndexAt § world.sprites.add(component: sprite, to: entity),
			hp: world.hp.sharedIndexAt § world.hp.add(component: hp, to: entity)
		)

		world.buildings.add(component: building, to: entity)

		return entity
	}
}
