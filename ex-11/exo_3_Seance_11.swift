extension Sequence {
  func forall(_ predicate: (Self.Element) -> Bool) -> Bool {
    for e in self {
      guard predicate(e) else { return false }
    }
    return true
  }
}

print([1, 2, 3, 4, 5].forall {$0 < 6})

enum People {
   case din, alph, mich, ali, syn
}

let people: Set<People> = [.din, .alph, .mich, .ali, .syn]

func isAssistant(people: People) -> Bool {
  switch people {
  case .din : return true
  case .mich : return true
  case .ali: return true
  default : return false
  }
}


func isWoman (people : People) -> Bool {
   switch people {
   case .ali : return true
   case .syn : return true
   default : return false
   }
}

print(people.contains(where: {isAssistant(people: $0) && !isWoman(people: $0) }))
