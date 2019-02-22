import Dispatch

@available(*, deprecated, message: "See `init(resolver:)`")
public func wrap<T>(_ body: (@escaping (T?, Error?) -> Void) throws -> Void) -> Promise<T> {
    return Promise { seal in
        try body(seal.resolve)
    }
}

@available(*, deprecated, message: "See `init(resolver:)`")
public func wrap<T>(_ body: (@escaping (T, Error?) -> Void) throws -> Void) -> Promise<T>  {
    return Promise { seal in
        try body(seal.resolve)
    }
}

@available(*, deprecated, message: "See `init(resolver:)`")
public func wrap<T>(_ body: (@escaping (Error?, T?) -> Void) throws -> Void) -> Promise<T> {
    return Promise { seal in
        try body(seal.resolve)
    }
}

@available(*, deprecated, message: "See `init(resolver:)`")
public func wrap(_ body: (@escaping (Error?) -> Void) throws -> Void) -> Promise<Void> {
    return Promise { seal in
        try body(seal.resolve)
    }
}

@available(*, deprecated, message: "See `init(resolver:)`")
public func wrap<T>(_ body: (@escaping (T) -> Void) throws -> Void) -> Promise<T> {
    return Promise { seal in
        try body(seal.fulfill)
    }
}

public extension Promise {
    @available(*, deprecated, message: "See `ensure`")
    func always(on q: DispatchQueue = .main, execute body: @escaping () -> Void) -> Promise {
        return ensure(on: q, body)
    }

    @discardableResult
    @available(*, deprecated, message: "See `catch`")
    func `catch`(on: DispatchQueue? = conf.Q.return, flags: DispatchWorkItemFlags? = nil, policy: CatchPolicy = conf.catchPolicy, execute body: @escaping(Error) -> Void) -> Self {
        let finalizer: PMKFinalizer = self.catch(on: on, flags: flags, policy: policy, execute: body)
        finalizer.finally {}
        return self
    }

    @discardableResult
    @available(*, deprecated, message: "See `recover`")
    func recover(on: DispatchQueue? = conf.Q.map, flags: DispatchWorkItemFlags? = nil, policy: CatchPolicy = conf.catchPolicy, execute body: @escaping(Error) throws -> T) -> Promise<T>{
        let rp: Promise<T> = Promise<T>(.pending)
        pipe {
            switch $0 {
            case .fulfilled(let value):
                rp.box.seal(.fulfilled(value))
            case .rejected(let error):
                if policy == .allErrors || !error.isCancelled {
                    on.async(flags: flags) {
                        do {
                            let rv = try body(error)
                            rp.box.seal(.fulfilled(rv))
                        } catch {
                            rp.box.seal(.rejected(error))
                        }
                    }
                } else {
                    rp.box.seal(.rejected(error))
                }
            }
        }
        return rp


    }
}

public extension Thenable {
#if PMKFullDeprecations
    /// disabled due to ambiguity with the other `.flatMap`
    @available(*, deprecated, message: "See: `compactMap`")
    func flatMap<U>(on: DispatchQueue? = conf.Q.map, _ transform: @escaping(T) throws -> U?) -> Promise<U> {
        return compactMap(on: on, transform)
    }
#endif
}

public extension Thenable where T: Sequence {
#if PMKFullDeprecations
    /// disabled due to ambiguity with the other `.map`
    @available(*, deprecated, message: "See: `mapValues`")
    func map<U>(on: DispatchQueue? = conf.Q.map, _ transform: @escaping(T.Iterator.Element) throws -> U) -> Promise<[U]> {
        return mapValues(on: on, transform)
    }

    /// disabled due to ambiguity with the other `.flatMap`
    @available(*, deprecated, message: "See: `flatMapValues`")
    func flatMap<U: Sequence>(on: DispatchQueue? = conf.Q.map, _ transform: @escaping(T.Iterator.Element) throws -> U) -> Promise<[U.Iterator.Element]> {
        return flatMapValues(on: on, transform)
    }
#endif

    @available(*, deprecated, message: "See: `filterValues`")
    func filter(on: DispatchQueue? = conf.Q.map, test: @escaping (T.Iterator.Element) -> Bool) -> Promise<[T.Iterator.Element]> {
        return filterValues(on: on, test)
    }
}

public extension Thenable where T: Collection {
    @available(*, deprecated, message: "See: `firstValue`")
    var first: Promise<T.Iterator.Element> {
        return firstValue
    }

    @available(*, deprecated, message: "See: `lastValue`")
    var last: Promise<T.Iterator.Element> {
        return lastValue
    }
}

public extension Thenable where T: Sequence, T.Iterator.Element: Comparable {
    @available(*, deprecated, message: "See: `sortedValues`")
    func sorted(on: DispatchQueue? = conf.Q.map) -> Promise<[T.Iterator.Element]> {
        return sortedValues(on: on)
    }
}

public extension CatchMixin{
    

}
