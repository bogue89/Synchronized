import Foundation

@propertyWrapper
public struct Synchronized<Value> {

    private var value: Value
    private var lock: NSLock

    public var wrappedValue: Value {
        mutating get {
            lock.lock()
            defer {
                lock.unlock()
            }
            return value
        }
        set {
            lock.lock()
            defer {
                lock.unlock()
            }
            value = newValue
        }
    }

    public init(wrappedValue: Value, lock: NSLock = .init()) {
        self.value = wrappedValue
        self.lock = lock
    }
}
