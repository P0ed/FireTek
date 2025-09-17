import SpriteKit
import Fx

final class Engine {
	private unowned let scene: SpaceScene
	private let world: World
	private let inputController: InputController

	private let msgsys: MessageSystem
	private let inputSystem: InputSystem
	private let physicsSystem: PhysicsSystem
	private let colsys: CollisionsSystem
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

	init(scene: SpaceScene, input: InputController, state: PlayerState = .make()) {
		world = World(initialState: state)
		self.scene = scene
		self.inputController = input

		inputSystem = InputSystem(world: world)
		msgsys = MessageSystem(world: world)
		renderingSystem = RenderingSystem(world: world, scene: scene)

		planetarySystem = PlanetarySystem(world: world, msgsys: msgsys)
		physicsSystem = PhysicsSystem(world: world)
		colsys = CollisionsSystem(world: world)
		weaponSystem = WeaponSystem(world: world)
		damageSystem = DamageSystem(world: world)
		projectileSystem = ProjectileSystem(
			world: world,
			colsys: colsys,
			damageSystem: damageSystem
		)

		targetSystem = TargetSystem(world: world, msgsys: msgsys)
		inputSystem.scan = { [player = world.players[0], targetSystem] in
			targetSystem.scan(entity: player)
		}
		aiSystem = AISystem(world: world)
		hudSystem = HUDSystem(world: world, hudNode: scene.hud)
		lifetimeSystem = LifetimeSystem(world: world)
		lootSystem = LootSystem(world: world, colsys: colsys)
	}

	private var currentTick: Int = 0
	func simulate() {
		var input = inputController.readInput()
		msgsys.update(input: &input)
		inputSystem.update(input: input)
		targetSystem.update()
		planetarySystem.update()
		physicsSystem.update()
		colsys.update()
		weaponSystem.update()
		projectileSystem.update()
		aiSystem.update(tick: currentTick)
		hudSystem.update(message: msgsys.text)
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
