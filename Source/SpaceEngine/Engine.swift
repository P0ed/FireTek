import SpriteKit
import Fx

final class Engine {
	@MutableProperty
	private(set) var state: GameState

	var restart = {}

	private unowned let scene: SpaceScene
	private let world: World
	private let player: Entity

	private let inputSystem: InputSystem
	private let physicsSystem: PhysicsSystem
	private let collisionsSystem: CollisionsSystem
	private let damageSystem: DamageSystem
	private let targetSystem: TargetSystem
	private var aiSystem: AISystem
	private var weaponSystem: WeaponSystem
	private let projectileSystem: ProjectileSystem
	private let lifetimeSystem: LifetimeSystem
	private let lootSystem: LootSystem
	private let hudSystem: HUDSystem
	private let planetarySystem: PlanetarySystem
	private let messageSystem: MessageSystem
	private let renderingSystem: RenderingSystem
	private let inputController: InputController

	init(scene: SpaceScene, input: InputController) {
		let state = GameState.make()
		let world = World()
		player = world.entityManager.create()
		self.state = state
		self.world = world
		self.scene = scene
		self.inputController = input

		state.setup(world: world, player: player)
		messageSystem = MessageSystem(world: world, player: player)
		renderingSystem = RenderingSystem(world: world, player: player, scene: scene)

		planetarySystem = PlanetarySystem(planets: world.planets, physics: world.physics)
		physicsSystem = PhysicsSystem(world: world)
		collisionsSystem = CollisionsSystem(world: world)

		weaponSystem = WeaponSystem(world: world)
		damageSystem = DamageSystem(world: world)
		projectileSystem = ProjectileSystem(world: world, collisionsSystem: collisionsSystem, damageSystem: damageSystem)

		inputSystem = InputSystem(world: world, player: player)
		targetSystem = TargetSystem(world: world, player: player, messageSystem: messageSystem)
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

		if !world.entityManager.isAlive(player) {
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
