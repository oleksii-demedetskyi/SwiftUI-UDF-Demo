typealias Command = () -> ()
typealias CommandWith<T> = (T) -> ()

func nop() {}
func nop<T>(_ value: T) {}

