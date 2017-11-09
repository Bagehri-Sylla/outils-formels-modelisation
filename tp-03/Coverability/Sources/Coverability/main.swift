import PetriKit
import CoverabilityLib


print("TP num03 Outils Formels: creation graphe de couverture\n")

print("Test avec la fonction createBoundedModel du TP\n") //ici on effectue un test pour le modele numero 1
do{
  let model = createBoundedModel()
  guard let r   = model.places.first(where: { $0.name == "r"  }),
        let s1  = model.places.first(where: { $0.name == "s1" }),
        let s2  = model.places.first(where: { $0.name == "s2" }),
        let s3  = model.places.first(where: { $0.name == "s3" }),
        let p   = model.places.first(where: { $0.name == "p"  }),
        let t   = model.places.first(where: { $0.name == "t"  }),
        let m   = model.places.first(where: { $0.name == "m"  }),
        let w1  = model.places.first(where: { $0.name == "w1" }),
        let w2  = model.places.first(where: { $0.name == "w2" }),
        let w3  = model.places.first(where: { $0.name == "w3" })

        else {
          fatalError("Modèle incorrecte !!! \n")
        }

  let initialMarking: CoverabilityMarking =
      [r: 1, p: 1, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

  print("Essai avec le marquage initial: \(initialMarking)\n")
  if model.coverabilityGraph(from: initialMarking) != nil{
    print("Création du graphe de couverture reussi avec succes \n")
    print("----------------------------------------------------------------------------- \n")
  }
  else{
    print("Une erreur a eu lieu à la création")
    print("----------------------------------------------------------------------------- \n")

  }
}

// Essai avec le second modèle
print("Test avec la fonction createBoundedModel du TP\n")
do{
  let model = createUnboundedModel()
  guard let s0 = model.places.first(where: { $0.name == "s0" }),
        let s1 = model.places.first(where: { $0.name == "s1" }),
        let s2 = model.places.first(where: { $0.name == "s2" }),
        let s3 = model.places.first(where: { $0.name == "s3" }),
        let s4 = model.places.first(where: { $0.name == "s4" }),
        let b  = model.places.first(where: { $0.name == "b"  })

        else {
          fatalError("Détection d'une erreur avec le modèle")
          print("----------------------------------------------------------------------------- \n")

        }

  let initialMarking: CoverabilityMarking =
      [s0: 1, s1: 0, s2: 1, s3: 0, s4: 1, b: 1]

  print("Essai avec le marquage initial: \(initialMarking)\n")
  if model.coverabilityGraph(from: initialMarking) != nil{
    print("Création du graphe de couverture reussi avec succes \n")
    print("----------------------------------------------------------------------------- \n")

  }
  else{
    print("Détection d'une erreur à la création")
    print("----------------------------------------------------------------------------- \n")

  }
}

print("Finish")
