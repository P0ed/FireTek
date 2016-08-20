import PowerCore

extension Store {

	func getComponentAt(idx: Int) -> () -> Component {
		let sharedIdx = sharedIndexAt(idx)
		return {
			self[sharedIdx.value]
		}
	}
}
