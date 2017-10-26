import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        // Write here the implementation of the marking graph generation.

        let transitions = self.transitions
        let noeudIn = MarkingGraph(marking: marking)
        var vst = [MarkingGraph]()
        var visit = [MarkingGraph]()

        vst.append(noeudIn)

        while vst.count != 0
        {
            let mtn = vst.removeFirst()
            visit.append(mtn)
            transitions.forEach
            { trans in
              if let nvxMarquage = trans.fire(from: mtn.marking)
              {
                        if let dejaVisite = visit.first(where: { $0.marking == nvxMarquage }) {
                            mtn.successors[trans] = dejaVisite
                        } else {
                            let dejaDecouvert = MarkingGraph(marking: nvxMarquage)
                            mtn.successors[trans] = dejaDecouvert
                            if (!vst.contains(where: { $0.marking == dejaDecouvert.marking})) {
                                vst.append(dejaDecouvert)
                            }
                    }
                }
            }
        }


        return noeudIn
    }



    //reponse a la question 4.1
    public func count (mark: MarkingGraph) -> Int{
      var dejaVu = [MarkingGraph]()
      var aVoir = [MarkingGraph]()

      aVoir.append(mark)
      while let mtn = aVoir.popLast() {
        dejaVu.append(mtn)
        for(_, succes) in mtn.successors{
          if !dejaVu.contains(where: {$0 === succes}) && !aVoir.contains(where: {$0 === succes}){
              aVoir.append(succes)
            }
          }
      }



      return dejaVu.count
    }


    //reponse a la question 4.2
    public func moreThanTwo (mark: MarkingGraph) -> Bool {
      var dejaVu = [MarkingGraph]()
      var aVoir = [MarkingGraph]()

      aVoir.append(mark)
      while let mtn = aVoir.popLast() {
        dejaVu.append(mtn)
        var nombreFumeur = 0;
        for (clef, vals) in mtn.marking {
            if (clef.name == "s1" || clef.name == "s2" || clef.name == "s3"){
               nombreFumeur += Int(vals)
            }
        }
        if (nombreFumeur > 1) {
          return true
        }
        for(_, successor) in mtn.successors{
          if !dejaVu.contains(where: {$0 === successor}) && !aVoir.contains(where: {$0 === successor}){
              aVoir.append(successor)
            }
          }
      }
      return false
    }


    //reponse a la question 4.3
    public func twoTimesSame (mark: MarkingGraph) -> Bool {
      var dejaVu = [MarkingGraph]()
      var aVoir = [MarkingGraph]()

      aVoir.append(mark)
      while let mtn = aVoir.popLast()
      {
         dejaVu.append(mtn)
         for (clef, vals) in mtn.marking {
            if (clef.name == "p" || clef.name == "t" || clef.name == "m"){
               if(vals > 1){
                 return true
               }
            }
        }
         for(_, succes) in mtn.successors{
          if !dejaVu.contains(where: {$0 === succes}) && !aVoir.contains(where: {$0 === succes}){
              aVoir.append(succes)
            }
          }
      }
      return false
    }

}
