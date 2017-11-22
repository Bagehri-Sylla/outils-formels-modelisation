import PetriKit

public extension PTNet {

<<<<<<< HEAD
    //transformation en marquage tirable (pour le graphe de couverture)

    public func coverabilityToPTMarking(with marquage : CoverabilityMarking, and k : [PTPlace]) -> PTMarking{
      var a : PTMarking = [:]

      for tempoVal in k
      {
        let el = correctValue(to : marquage[tempoVal]!)!
        a[tempoVal] = el
      }
      return a
    }

    //transformation pour le graphe de couverture en un marquage tirable
    public func ptmarkingToCoverability(with marking: PTMarking, and k : [PTPlace]) ->CoverabilityMarking{
      var tempoVal : CoverabilityMarking = [:]
      for vals in k
      {
        tempoVal[vals] = .some(marking[vals]!)
        if(500 < tempoVal[vals]!)
        {
          tempoVal[vals] = .omega
        }
      }
      return tempoVal
    }

    //correction des potentielles erreurs à cause de la présence d'omega
    public func correctValue(to jeton: Token) -> UInt? {
      if case .some(let valeurs) = jeton {
        return valeurs
      }
      else {
        return 1000
      }
    }

    // ici on regarde par rapport à une liste si un noeud y est ou non
    public func verify(at markaj : [CoverabilityMarking], to ajout : CoverabilityMarking) -> Int
    {
      var valeurs = 0
      for i in 0...markaj.count-1
      {
        if (markaj[i] == ajout)
        {
          valeurs = 1
        }
        if (ajout > markaj[i])
        {
          valeurs = i+2}
      }
      return valeurs
    }

    // permet si nécessaire l'ajout de omega comme jetons
    public func Omega(from mark : CoverabilityMarking, with marc : CoverabilityMarking, and x : [PTPlace])  -> CoverabilityMarking?
    {
      var tempoVal = marc
      for trans in x
      {
        if (marc[trans]! < tempoVal[trans]!)
        {
          tempoVal[trans] = .omega
        }
      }
      return tempoVal
=======
    /// Computes the coverability graph of this P/T-net, starting from the given marking.
    ///
    /// Implementation note:
    /// It is easier to build the coverability graph in a recursive depth-first manner than with
    /// stacks, because we need to keep track of predecessor nodes as we process new ones. That's
    /// why the algorithm is actually implemented in `computeSuccessors(of:_:_:)`.
    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        // Create the initial node of the coverability graph.
        let initialNode = CoverabilityGraph(marking: marking)

        // An array of `CoverabilityGraph` instances that keeps track of the nodes we've already
        // visited. It initially contains the initial node of the coverability graph.
        var seen = [initialNode]

        // Compute the successors of the initial node. Notice that we pass a reference to the array
        // of visited nodes, and an initially empty array of predecessors.
        self.computeSuccessors(of: initialNode, seen: &seen, predecessors: [])

        // Return the initial node once its successors (i.e. the rest of the graph) generated.
        return initialNode
    }

    /// Computes the successors of a coverability node in a recursive depth-first manner.
    ///
    /// This method recursively computes all its successors. It accepts as parameter the node whose
    /// successors shall be computed, an array of nodes that have already been visited and an array
    /// of predecessor nodes.
    ///
    /// The algorithm boils down to a depth-first search that recursively visits, for each node,
    /// the list of successors we can obtain by firing the transitions of the P/T-net from the
    /// marking associated with the currently visited node. To avoid infinte recursions, we check
    /// for each produced marking if there doesn't already exists a previously created node
    /// associated with the same marking. The detection of ω is done by checking the produced
    /// markings against that of predecessor nodes.
    ///
    /// Note that the `seen` parameter (i.e. the list of nodes that have already been visited) is
    /// declared `inout`. That's because `computeSuccessors(of:_:_:)` has to be able to notify its
    /// callers about the nodes it visited, so as to avoid infinite recursions.
    func computeSuccessors(
        of currentNode: CoverabilityGraph,
        seen          : inout [CoverabilityGraph],
        predecessors  : [CoverabilityGraph])
    {
        for transition in self.transitions {
            // Compute, if possible the coverability marking obtained by firing the transition from
            // the marking associated with the currently visited node.
            // Note that because `currentNode.marking` is an instance of `CoverabilityMarking`, we
            // can't use the methods `isFireable(from:)` and `fire(from:)` provided by PetriKit.
            // Instead, we have to use our own methods (see the extension of below).
            guard var nextMarking = transition.fire(from: currentNode.marking) else {
                // The transition was not fireable (i.e. `fire(from:)` return a nil value), so we
                // continue to the next one.
                continue
            }

            // Notice how we add the currently visited node as a predecessor before checking for
            // unboundedness.
            let predecessors = predecessors + [currentNode]

            // Check if the marking we computed is greater than any of the markings associated with
            // the predecessor nodes. In other words, check if the Petri Net is unbounded.
            if predecessors.contains(where: { nextMarking > $0.marking }) {
                // Since the marking we computed is greater than at least one of the markings we've
                // seen so far, we've to create a new marking where we've to put ω for each place
                // whose number of token is strictly superior to that of all previously visited
                // smaller markings.
                for predecessor in predecessors {
                    // Ignore markings that aren't smaller.
                    guard nextMarking > predecessor.marking else { continue }

                    // Set ω wherever it is needed.
                    for (place, tokens) in nextMarking {
                        if predecessor.marking[place]! < tokens {
                            nextMarking[place] = .omega
                        }
                    }
                }
            }

            // Check if the marking we computed has already been seen.
            if let previouslySeen = seen.first(where: { $0.marking == nextMarking }) {
                // We found a node whose associated marking is the same as that we obtained after
                // firing the transition. Hence we can mark it as successor of the current node,
                // and continue to the next transition.
                currentNode.successors[transition] = previouslySeen
                continue
            }

            // Use the marking we computed to create a new coverability node and mark it as
            // successor of the currently visited one.
            let successor = CoverabilityGraph(marking: nextMarking)
            currentNode.successors[transition] = successor

            // Mark this newly created successor as seen.
            seen.append(successor)

            // Compute its successors. Notice that we pass a reference to the array of visited
            // nodes, because the parameter is declared inout.
            self.computeSuccessors(
                of          : successor,
                seen        : &seen,
                predecessors: predecessors)
        }
    }

}

public extension PTTransition {

    public func isFireable(from marking: CoverabilityMarking) -> Bool {
        for arc in self.preconditions {
            // Note that because `marking[arc.place]!` returns an instance of `Token`, we can't
            // directly compare it is `arc.tokens`, which is an instance of `UInt`. However, the
            // `<` operator is defined for two `Token` operands (see `Token.swift`). So all we have
            // to do is to wrap `arc.tokens` into an instance of `Token`.
            if marking[arc.place]! < .some(arc.tokens) {
                return false
            }
        }

        // If not precondition was found violated, the transition is fireable.
        return true
    }

    public func fire(from marking: CoverabilityMarking) -> CoverabilityMarking? {
        // Make sure the transition is fireable.
        guard self.isFireable(from: marking) else {
            return nil
        }

        // Copy the marking (i.e. state) before the transition is fired.
        var result = marking

        // Consume the appropriate number of tokens from each place in precondition.
        for arc in self.preconditions {
            switch marking[arc.place]! {
            case .some(let tokens):
                // In that case, `marking[arc.place]!` represents a concrete number of tokens, so
                // we have to actually substract the number of tokens the transition consumes.
                result[arc.place] = .some(tokens - arc.tokens)
            case .omega:
                // In that case, `marking[arc.place]!` represents ω, so can leave it untouched.
                // Remember that `ω - n = ω`.
                break
            }
        }

        // Produce the appropriate number of tokens to each place in postcondition.
        for arc in self.postconditions {
            switch result[arc.place]! {
            case .some(let tokens):
                // In that case, `marking[arc.place]!` represents a concrete number of tokens, so
                // we have to actually add the number of tokens the transition produces.
                result[arc.place] = .some(tokens + arc.tokens)
            case .omega:
                // In that case, `marking[arc.place]!` represents ω, so can leave it untouched.
                // Remember that `ω + n = ω`.
                break
            }
        }

        return result
>>>>>>> 24a3bfda245ab543c567d19fbb498c8b21e88ead
    }

    public func coverabilityGraph(from markajInit: CoverabilityMarking) -> CoverabilityGraph? {

        // ici les set des transitions et des places sont Transformés en array
        var sTrans = Array (transitions) // ici on sort les valeurs de l'array
        sTrans.sort{$0.name < $1.name}
        let sPlaces = Array(places)

        // ici on effectue une initialisation des valeurs
        var listeDeMarquage : [CoverabilityMarking] = [markajInit]
        var listeDeGraph : [CoverabilityGraph] = []
        var el: CoverabilityMarking
        let retourneUnGraphe = CoverabilityGraph(marking: markajInit, successors: [:])
        var count = 0

        //condition qui stop la boucle principale lorsque le count est supérieur à la taille de la listes de marquage
        while(count < listeDeMarquage.count)
        {
          //ici la boucle crée les marquages du graphe de couverture et effectue les itérations
          for transit in sTrans{

            // transformation du marquage pour qu'il soit tirable
            let marquagePetri = coverabilityToPTMarking(with: listeDeMarquage[count], and: sPlaces)
            if let stopTrans = transit.fire(from: marquagePetri){

              // reconversion pour le graphe de couverture en un marquage
              let changerMarquage = ptmarkingToCoverability(with: stopTrans, and: sPlaces)
              // création des noeuds pour le marquage
              let couvertureNew = CoverabilityGraph(marking: changerMarquage, successors: [:])
              // ici on ajoute au successeur le nouveau noeud
              retourneUnGraphe.successors[transit] = couvertureNew
            }
            //  condition qui regrde si le successeur existe
            if(retourneUnGraphe.successors[transit] != nil){
              // son marquage est ajouté à la variable
              el = retourneUnGraphe.successors[transit]!.marking
              // on regarde si il est dans la liste
              let ok = verify(at: listeDeMarquage, to: el)
              if (ok != 1)
              {
                if (ok > 1)
                {
                  el = Omega(from : listeDeMarquage[ok-2], with : el, and : sPlaces)!
                }
                 // ici on ajoute le noeud à la correspondante
                listeDeGraph.append(retourneUnGraphe)
                // et on fait la même chose ici
                listeDeMarquage.append(el)
              }
            }
          }
          count = count + 1
        }
        return retourneUnGraphe
      }
}
