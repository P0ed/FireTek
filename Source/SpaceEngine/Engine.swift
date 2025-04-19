import SpriteKit
import Fx

final class Engine {
	@MutableProperty
	private(set) var state: GameState

	var restart: () -> Void {
		get { levelSystem.restart }
		set { levelSystem.restart = newValue }
	}

	private unowned let scene: SpaceScene
	private let world: World

	private let levelSystem: LevelSystem
	private let spriteSpawnSystem: SpriteSpawnSystem
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
	private let renderingSystem: RenderingSystem

	init(scene: SpaceScene, input: InputController) {
		let state = GameState.make()
		let world = World()
		self.state = state
		self.world = world
		self.scene = scene

		spriteSpawnSystem = SpriteSpawnSystem(scene: scene, store: world.physics)
		levelSystem = LevelSystem(world: world, state: state)
		physicsSystem = PhysicsSystem(world: world)
		collisionsSystem = CollisionsSystem(world: world)

		weaponSystem = WeaponSystem(world: world)
		damageSystem = DamageSystem(world: world)
		projectileSystem = ProjectileSystem(world: world, collisionsSystem: collisionsSystem, damageSystem: damageSystem)

		inputSystem = InputSystem(world: world, player: levelSystem.player, inputController: input)
		targetSystem = TargetSystem(world: world, player: levelSystem.player, inputController: input)
		aiSystem = AISystem(world: world)

		lifetimeSystem = LifetimeSystem(world: world)

		lootSystem = LootSystem(world: world, collisionsSystem: collisionsSystem)

		hudSystem = HUDSystem(world: world, player: levelSystem.player, hudNode: scene.hud)

		planetarySystem = PlanetarySystem(planets: world.planets, physics: world.physics)
		renderingSystem = RenderingSystem(
			world: world,
			ref: world.physics.weakRefOf(levelSystem.player)
		)
	}

	private var currentTick: Int = 0
	func simulate() {
		inputSystem.update()
		planetarySystem.update()
		physicsSystem.update()
		collisionsSystem.update()

		weaponSystem.update()
		targetSystem.update()
		projectileSystem.update()

		levelSystem.update()
		aiSystem.update(tick: currentTick)

		hudSystem.update()

		lootSystem.update()
		lifetimeSystem.update()

		currentTick &+= 1
	}

	func didFinishUpdate() {
		renderingSystem.update()
	}
}

extension TimeInterval {
	static let timeStep: TimeInterval = 1.0 / 60.0
}
