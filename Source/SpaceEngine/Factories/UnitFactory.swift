import Fx
import SpriteKit

enum UnitFactory {

	@discardableResult
	static func createTank(world: World, ship data: GameState.Ship, position: CGPoint, team: Team) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createShipSprite(entity)
		let physics = PhysicsComponent(
			node: sprite,
			position: position,
			category: .ship.union(team.category),
			contacts: .crystal
		)
		let shipRef = ShipRef(
			physics: world.physics.sharedIndexAt § world.physics.add(component: physics, to: entity),
			input: world.input.sharedIndexAt § world.input.add(component: .empty, to: entity),
			ship: world.ships.sharedIndexAt § world.ships.add(component: data.stats, to: entity)
		)

		world.messages.add(component: Message(text: data.text), to: entity)
		world.shipRefs.add(component: shipRef, to: entity)
		world.targets.add(component: .init(), to: entity)
		world.loot.add(component: LootComponent(crystal: .orange, count: 3), to: entity)

		return entity
	}

	@discardableResult
	static func createAIPlayer(world: World, position: CGPoint) -> Entity {
		let ship = GameState.makeShip(rarity: .common)
		let entity = createTank(world: world, ship: ship, position: position, team: .red)
		let vehicle = world.shipRefs.sharedIndexAt § world.shipRefs.indexOf(entity)!

		let ai = VehicleAIComponent(vehicle: vehicle, state: .hold(.zero), target: nil)
		world.vehicleAI.add(component: ai, to: entity)

		return entity
	}

	@discardableResult
	static func addCrystal(world: World, crystal: Crystal, at position: CGPoint, moveBy offset: CGVector) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createCrystal(entity: entity, crystal: crystal)
		sprite.run(.group([
			.repeatForever(.rotate(byAngle: 1, duration: 0.6)),
			.move(by: offset, duration: 0.6)
		]))

		let node = SKNode()
		node.addChild(sprite)

		let physics = PhysicsComponent(
			node: node,
			position: position,
			category: .crystal
		)

		world.physics.add(component: physics, to: entity)
		world.crystals.add(component: crystal, to: entity)
		world.lifetime.add(component: LifetimeComponent(lifetime: 900), to: entity)

		return entity
	}
}
