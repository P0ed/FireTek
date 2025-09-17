import Fx
import SpriteKit

extension World {
	var unitFactory: UnitFactory { .init(world: self) }
}

struct UnitFactory {
	var world: World

	func makeTank(entity: Entity, ship: PlayerState.Ship, position: CGPoint, category: Category, loot: Array4<Crystal> = []) {
		let sprite = SpriteFactory.createShipSprite(entity)
		let physics = Physics(
			node: sprite,
			position: position,
			category: .ship.union(category),
			contacts: .crystal
		)
		let shipRef = ShipRef(
			physics: world.physics.sharedIndexAt § world.physics.add(component: physics, to: entity),
			input: world.input.sharedIndexAt § world.input.add(component: .empty, to: entity),
			ship: world.ships.sharedIndexAt § world.ships.add(component: ship.stats, to: entity),
			info: ship.text
		)

		world.shipRefs.add(component: shipRef, to: entity)
		world.crystalBank.add(component: loot, to: entity)
	}

	func makeAIPlayer(entity: Entity, position: CGPoint) {
		let ship = PlayerState.makeShip(rank: .a)
		makeTank(entity: entity, ship: ship, position: position, category: .red, loot: [.red, .yellow, .blue])
		let vehicle = world.shipRefs.sharedIndexAt § world.shipRefs.indexOf(entity)!
		let ai = VehicleAIComponent(vehicle: vehicle, state: .hold(.zero), target: nil)
		world.vehicleAI.add(component: ai, to: entity)
	}

	@discardableResult
	func addCrystal(crystal: Crystal, at position: CGPoint, moveBy offset: CGVector) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createCrystal(entity: entity, crystal: crystal)
		sprite.run(.repeatForever(.rotate(byAngle: 4, duration: 1)))

		let node = SKNode()
		node.addChild(sprite)

		let physics = Physics(
			node: node,
			position: position + offset.point,
			momentum: offset / 128,
			category: .crystal
		)

		world.physics.add(component: physics, to: entity)
		world.crystals.add(component: crystal, to: entity)
		world.lifetime.add(component: LifetimeComponent(lifetime: 900), to: entity)

		return entity
	}

	@discardableResult
	func createSystem(data: StarSystemData) -> [Entity] {
		data.planets.map { createPlanet(data: $0) }
	}

	func createPlanet(data: StarSystemData.Planet) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createPlanet(entity: entity, data: data)
		let physics = Physics(node: sprite, position: data.position)

		let pidx = world.physics.add(component: physics, to: entity)
		let phyRef = world.physics.sharedIndexAt(pidx)

		let planet = PlanetComponent(
			physics: phyRef,
			orbit: data.orbit,
			velocity: data.velocity,
			angle: data.angle,
			hasShop: data.hasShop,
			orbiting: []
		)
		world.planets.add(component: planet, to: entity)

		return entity
	}

	@discardableResult
	func createProjectile(at position: CGPoint, velocity: CGVector, angle: CGFloat, projectile: ProjectileComponent, team: Team?) -> Entity {
		let entity = world.entityManager.create()
		let sprite = SpriteFactory.createProjectileSprite(entity, type: projectile.type)
		sprite.run(.play(projectile.type.fireSound))

		let physics = Physics(
			node: sprite,
			position: position,
			momentum: velocity,
			rotation: angle,
			category: .projectile.union(projectile.type == .torpedo ? team?.category ?? [] : []),
			contacts: team?.opposite.category ?? [.blu, .red]
		)
		let lifetime = LifetimeComponent(lifetime: projectile.type == .torpedo ? 360 : 180)

		world.physics.add(component: physics, to: entity)
		world.projectiles.add(component: projectile, to: entity)
		world.lifetime.add(component: lifetime, to: entity)

		return entity
	}

	@discardableResult
	func makeExplosion(at position: CGPoint, angle: CGFloat, textures: [SKTexture], sound: Sound) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SKSpriteNode(texture: textures.first)
		sprite.run(.group([
			.animate(with: textures, timePerFrame: 0.1),
			.play(sound)
		]))

		world.physics.add(component: Physics(node: sprite, position: position, rotation: angle), to: entity)
		world.lifetime.add(component: LifetimeComponent(lifetime: 60), to: entity)

		return entity
	}
}
