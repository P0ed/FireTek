import SpriteKit
import PowerCore
import Fx

final class SpriteSpawnSystem {

	let disposable = CompositeDisposable()

	init(scene: SKScene, store: Store<SpriteComponent>) {

		disposable += store.newComponents.observe { idx in
			scene.addChild(store[idx].sprite)
		}

		disposable += store.removedComponents.observe { entity, component in
			component.sprite.removeFromParent()
		}
	}
}
