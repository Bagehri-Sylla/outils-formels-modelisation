extension PredicateNet {

    /// Returns the marking graph of a bounded predicate net.
    public func markingGraph(from marking: MarkingType) -> PredicateMarkingNode<T>? {
        // Write your code here ...

        // Note that I created the two static methods `equals(_:_:)` and `greater(_:_:)` to help
        // you compare predicate markings. You can use them as the following:
        //
        //     PredicateNet.equals(someMarking, someOtherMarking)
        //     PredicateNet.greater(someMarking, someOtherMarking)
        //
        // You may use these methods to check if you've already visited a marking, or if the model
        // is unbounded.

        //nous allons ici définir l'ensemble des transitions, une liste de transitions avec binding, et
        // l'ensemble des marquages qui devront etre renvoye

        let Trst = self.transitions
        let preMkg = PredicateMarkingNode<T>(marking: marking, successors: [:])
        var markOk = [preMkg]
        var ilReste = [preMkg]
        var bdg = [PredicateTransition<T>.Binding]()

        //nous allons ici creer une boucle while, qui se répètera jusqu'a
        // que le nombre de marquage à traiter sera nul
        while(ilReste.last) != nil
        {
          let W = ilReste.popLast()
          markOk.append(W!)
          let marKourant = W!.marking

          //ici on tire toutes les transitions qui sont bindées
          for i in Trst{
            bdg = i.fireableBingings(from: marKourant)

            var nvlle_successor : PredicateBindingMap<T> = [:]

            //ici nous alllons faire une itération sur tout les bindings existant, nous allons effectuer un tire
            //de transitions, puis dans la première condition if on va borner le marquages
            //et la seconde condition if nous prmet de vérifier qu'un marquage n'existe pas deux fois
            for bind in bdg
            {
              if let tirage = i.fire(from: marKourant, with: bind)
              {
                let Wnew = PredicateMarkingNode<T>(marking: tirage, successors: [:])

                if (markOk.contains(where: {PredicateNet.greater(Wnew.marking, $0.marking)}) == true)
                {
                  return nil
                }

                if (markOk.contains(where:{PredicateNet.equals($0.marking, Wnew.marking)}) == false)
                {
                  ilReste.append(Wnew)
                  markOk.append(Wnew)

                  nvlle_successor[bind] = Wnew
                  W!.successors.updateValue(nvlle_successor, forKey: i)
                }
              }
            }

          }
        }
        return preMkg
    }

    // MARK: Internals

    private static func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }
        for (place, tokens) in lhs {
            guard tokens.count == rhs[place]!.count else { return false }
            for t in tokens {
                guard rhs[place]!.contains(t)
                    else {
                        return false
                }
            }
        }
        return true
    }

    private static func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }

        var hasGreater = false
        for (place, tokens) in lhs {
            guard tokens.count >= rhs[place]!.count else { return false }
            hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
            for t in rhs[place]! {
                guard tokens.contains(t)
                    else {
                        return false
                }
            }
        }
        return hasGreater
    }

}

/// The type of nodes in the marking graph of predicate nets.
public class PredicateMarkingNode<T: Equatable>: Sequence {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: [PredicateTransition<T>: PredicateBindingMap<T>] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public func makeIterator() -> AnyIterator<PredicateMarkingNode> {
        var visited = [self]
        var toVisit = [self]

        return AnyIterator {
            guard let currentNode = toVisit.popLast() else {
                return nil
            }

            var unvisited: [PredicateMarkingNode] = []
            for (_, successorsByBinding) in currentNode.successors {
                for (_, successor) in successorsByBinding {
                    if !visited.contains(where: { $0 === successor }) {
                        unvisited.append(successor)
                    }
                }
            }

            visited.append(contentsOf: unvisited)
            toVisit.append(contentsOf: unvisited)

            return currentNode
        }
    }

    public var count: Int {
        var result = 0
        for _ in self {
            result += 1
        }
        return result
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: [PredicateTransition<T>: PredicateBindingMap<T>]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable>: Collection {

    public typealias Key     = PredicateTransition<T>.Binding
    public typealias Value   = PredicateMarkingNode<T>
    public typealias Element = (key: Key, value: Value)

    public var startIndex: Int {
        return self.storage.startIndex
    }

    public var endIndex: Int {
        return self.storage.endIndex
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int) -> Element {
        return self.storage[index]
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

extension PredicateBindingMap: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: ([Variable: T], PredicateMarkingNode<T>)...) {
        self.storage = elements
    }

}
