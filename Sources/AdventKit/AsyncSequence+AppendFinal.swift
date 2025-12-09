//
//  AsyncSequence+AppendFinal.swift
//  AdventOfCode
//
//  Created by Matthew Judy on 12/7/25.
//
import Foundation


public extension AsyncSequence where Self: Sendable, Element: Sendable
{
    /// Appends a final, Sendable element to an existing, Sendable AsyncSequence.
    func appendingFinalValue(_ finalValue: Element) -> AsyncStream<Element>
    {
        AsyncStream
        {
            continuation in
            let task = Task
            {
                do
                {
                    // Iterate over the original sequence and yield each element.
                    // The compiler now knows this is safe because Self and Element are Sendable.
                    for try await element in self { continuation.yield(element) }

                    // After the original sequence finishes, yield the final Sendable value.
                    continuation.yield(finalValue)

                    // Mark the end of the new sequence.
                    continuation.finish()
                }
                catch
                {
                    // If an error occurs, finish the stream.
                    // Use AsyncThrowingStream if you need to propagate the actual error.
                    continuation.finish()
                }
            }

            // The onTermination handler is also a @Sendable closure.
            // It safely captures the 'task' variable (which is a Sendable struct)
            continuation.onTermination =
            {
                @Sendable _ in
                task.cancel()
            }
        }
    }
}
