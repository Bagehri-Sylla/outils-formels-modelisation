import PetriKit

public extension PTNet {

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
