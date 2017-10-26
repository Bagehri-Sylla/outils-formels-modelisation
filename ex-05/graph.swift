public class MarkingGraph {

    public typealias Marking = [String: Int]

    public let marking   : Marking
    public var successors: [String: MarkingGraph]

    public init(marking: Marking, successors: [String: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

func countNodes(markingGraph: MarkingGraph  -> Int {
  var seen    = [markingGraph]
  var toVisit = [markingGraph]

  while let current = toVisit.pop
  for

}
