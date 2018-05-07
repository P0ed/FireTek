import SpriteKit
import Fx

final class MainMenuScene: Scene {
	private let table: TableUI

	override init(size: CGSize) {

		let menuItems = [
			MenuItem(text: "New game", action: {}),
			MenuItem(text: "Exit", action: { exit(0) })
		]

		table = TableUI(items: menuItems.map { $0.asTableItem })

		super.init(size: size)

		with(table.node) { node in
			addChild(node)
		}

		table.layout(size: modify(size) { $0.width = 400; return })
	}

	required init?(coder aDecoder: NSCoder) { fatalError() }
}
