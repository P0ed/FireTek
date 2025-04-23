import SpriteKit
import Fx

final class Engine {
	private unowned let scene: SpaceScene
	private let world: World
	private var state: GameState
	private let inputController: InputController

	private let messageSystem: MessageSystem
	private let inputSystem: InputSystem
	private let physicsSystem: PhysicsSystem
	private let collisionsSystem: CollisionsSystem
	private let planetarySystem: PlanetarySystem
	private let damageSystem: DamageSystem
	private let targetSystem: TargetSystem
	private let aiSystem: AISystem
	private let weaponSystem: WeaponSystem
	private let projectileSystem: ProjectileSystem
	private let lifetimeSystem: LifetimeSystem
	private let lootSystem: LootSystem
	private let hudSystem: HUDSystem
	private let renderingSystem: RenderingSystem

	var restart = {}

	init(scene: SpaceScene, input: InputController) {
		state = GameState.make()
		world = World()
		self.scene = scene
		self.inputController = input

		world.load(state: state)
		let player = world.players[0]

		messageSystem = MessageSystem(world: world, player: player)
		renderingSystem = RenderingSystem(world: world, player: player, scene: scene)

		planetarySystem = PlanetarySystem(planets: world.planets, physics: world.physics, msgsys: messageSystem)
		physicsSystem = PhysicsSystem(world: world)
		collisionsSystem = CollisionsSystem(world: world)

		weaponSystem = WeaponSystem(world: world)
		damageSystem = DamageSystem(world: world)
		projectileSystem = ProjectileSystem(world: world, collisionsSystem: collisionsSystem, damageSystem: damageSystem)

		inputSystem = InputSystem(world: world, player: player)
		targetSystem = TargetSystem(world: world, player: player, messageSystem: messageSystem)
		inputSystem.scan = { [targetSystem] in targetSystem.scan(entity: player) }
		aiSystem = AISystem(world: world)
		hudSystem = HUDSystem(world: world, player: player, hudNode: scene.hud)
		lifetimeSystem = LifetimeSystem(world: world)
		lootSystem = LootSystem(world: world, collisionsSystem: collisionsSystem)
	}

	private var currentTick: Int = 0
	func simulate() {
		var input = inputController.readInput()
		messageSystem.update(input: &input)
		inputSystem.update(input: input)
		targetSystem.update()
		planetarySystem.update()
		physicsSystem.update()
		collisionsSystem.update()
		weaponSystem.update()
		projectileSystem.update()
		aiSystem.update(tick: currentTick)
		hudSystem.update(message: messageSystem.text)
		lootSystem.update()
		lifetimeSystem.update()

		if !world.players.contains(where: world.entityManager.isAlive) {
			restart()
		}

		currentTick &+= 1
	}

	func didFinishUpdate() {
		renderingSystem.update()
	}
}

extension TimeInterval {
	static let timeStep: TimeInterval = 1.0 / 60.0
}
