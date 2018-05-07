import SpriteKit
import Fx

final class MainMenuScene: Scene {
	private let table: TableUI

	override init() {

		let menuItems = [
			MenuItem(text: "New game", action: {}),
			MenuItem(text: "Exit", action: { exit(0) })
		]

		table = TableUI(items: menuItems.map { $0.asTableItem })

		super.init()

		with(table.node) { node in
			addChild(node)
		}
		table.layout(size: size)
	}

	required init?(coder aDecoder: NSCoder) { fatalError() }
}
