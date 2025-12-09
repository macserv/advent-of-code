//
//  AsyncSequence+Enumerated.swift
//  AdventKit
//
//  Created by Matthew Judy on 12/21/23.
//
//  TODO: Use the implementation found in swift-async-algorithms when this PR is merged:
//  https://github.com/apple/swift-async-algorithms/pull/261
//


/// An enumeration of the elements of an AsyncSequence.
///
/// `AsyncEnumeratedSequence` generates a sequence of pairs (*n*, *x*), where *n*s are
/// consecutive `Int` values starting at zero, and *x*s are the elements from an
/// base AsyncSequence.
///
/// To create an instance of `EnumeratedSequence`, call `enumerated()` on an
/// AsyncSequence.
public struct AsyncEnumeratedSequence<Base: AsyncSequence>
{
    @usableFromInline
    let base: Base

    @usableFromInline
    init(_ base: Base)
    {
        self.base = base
    }
}


extension AsyncEnumeratedSequence: AsyncSequence
{
    public typealias Element = (Int, Base.Element)

    public struct AsyncIterator: AsyncIteratorProtocol
    {
        @usableFromInline
        var baseIterator: Base.AsyncIterator
        @usableFromInline
        var index: Int

        @usableFromInline
        init(baseIterator: Base.AsyncIterator)
        {
            self.baseIterator = baseIterator
            self.index = 0
        }

        @inlinable
        public mutating func next() async rethrows -> AsyncEnumeratedSequence.Element?
        {
            let value = try await self.baseIterator.next().map { (self.index, $0) }
            self.index += 1
            return value
        }
    }

    @inlinable
    public consuming func makeAsyncIterator() -> AsyncIterator
    {
        return .init(baseIterator: self.base.makeAsyncIterator())
    }
}


extension AsyncEnumeratedSequence: Sendable where Base: Sendable {}


extension AsyncSequence
{
    /// Return an enumaterated AsyncSequence
    public func enumerated() -> AsyncEnumeratedSequence<Self> { return AsyncEnumeratedSequence(self) }
}


