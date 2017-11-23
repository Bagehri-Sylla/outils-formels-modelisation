import PetriKit
import PhilosophersLib

do {
    enum C: CustomStringConvertible {
        case b, v, o

        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }

    func g(binding: PredicateTransition<C>.Binding) -> C {
        switch binding["x"]! {
        case .b: return .v
        case .v: return .b
        case .o: return .o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
        ])

    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
}

print()

do {
    let philosophers = lockFreePhilosophers(n: 5)

    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }

    let firstMarkingGraph = philosophers.markingGraph(from: philosophers.initialMarking!)
    print("")
    print("On retrouve dans ce cas" ,firstMarkingGraph!.count, "possibilités de marquages sans avoir de bloquage")
    print("")
    print("")
    print("-----------------------------------------------------------------------------------------------------------")
    print("")
    print("")

}

do
{
  let philosophers = lockablePhilosophers(n: 5)
  for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10)
  {
    print(m)
  }

  let secondMarkingGraph = philosophers.markingGraph(from: philosophers.initialMarking!)
  print("")
  print("On retrouve dans ce cas" ,secondMarkingGraph!.count, "possibilités de marquages avec bloquage")
  print("")
  print("")
  print("-----------------------------------------------------------------------------------------------------------")
  print("")
  print("")
}
