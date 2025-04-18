import Fx
import SpriteKit

enum UnitFactory {

	@discardableResult
	static func createTank(world: World, ship data: GameState.Ship, position: CGPoint, team: Team) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createShipSprite(entity, at: position)
		let physics = PhysicsComponent(
			node: sprite.sprite,
			position: position,
			category: team == .blue ? .blueShips : .redShips
		)

		let shipRef = ShipRef(
			sprite: world.sprites.sharedIndexAt § world.sprites.add(component: sprite, to: entity),
			physics: world.physics.sharedIndexAt § world.physics.add(component: physics, to: entity),
			input: world.input.sharedIndexAt § world.input.add(component: .empty, to: entity),
			ship: world.ships.sharedIndexAt § world.ships.add(component: data.stats, to: entity)
		)
		let mapItem = MapItem(
			type: team == .blue ? .ally : .enemy,
			node: sprite.sprite
		)

		world.shipRefs.add(component: shipRef, to: entity)
		world.team.add(component: team, to: entity)
		world.targets.add(component: .init(), to: entity)
		world.mapItems.add(component: mapItem, to: entity)

		world.loot.add(component: LootComponent(crystal: .orange, count: 3), to: entity)

		return entity
	}

	@discardableResult
	static func createAIPlayer(world: World, position: CGPoint) -> Entity {
		let ship = GameState.makeShip(rarity: .common)
		let entity = createTank(world: world, ship: ship, position: position, team: .red)
		let vehicle = world.shipRefs.sharedIndexAt § world.shipRefs.indexOf(entity)!

		let ai = VehicleAIComponent(vehicle: vehicle, state: .hold(CGPoint(x: 0, y: 0)), target: nil)
		world.vehicleAI.add(component: ai, to: entity)

		return entity
	}

	@discardableResult
	static func addCrystal(world: World, crystal: Crystal, at position: CGPoint, moveBy offset: CGVector) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createCrystal(entity: entity, at: position, crystal: crystal)

		sprite.sprite.run(.group([
			.repeatForever(.rotate(byAngle: 1, duration: 0.6)),
			.move(by: offset, duration: 0.6)
		]))

		let physics = PhysicsComponent(
			node: sprite.sprite,
			position: position,
			category: .crystal
		)

		world.physics.add(component: physics, to: entity)
		world.sprites.add(component: sprite, to: entity)
		world.crystals.add(component: crystal, to: entity)
		world.lifetime.add(component: LifetimeComponent(lifetime: 640), to: entity)

		return entity
	}
}
