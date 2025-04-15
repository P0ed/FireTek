import SpriteKit
import Fx

struct SpriteSpawnSystem {

	let disposable = CompositeDisposable()

	init(scene: SKScene, store: Store<SpriteComponent>) {

		disposable += store.newComponents.observe { [unowned scene] index in
			scene.addChild(store[index].sprite)
		}

		disposable += store.removedComponents.observe { entity, component in
			component.sprite.removeFromParent()
		}
	}
}
