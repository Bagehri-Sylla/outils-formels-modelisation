import ProofKitLib

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"

let ex1 = !(a && (b || c)) //formule exemple 1
print("ex1.")
print("formula: \(ex1)") //affichage de la formule
print("nnf    : \(ex1.nnf)") //affichage forme nnf de la formule
print("cnf    : \(ex1.cnf)") //affichage forme cnf de la formule
print("dnf    : \(ex1.dnf)") //affichage forme dnf de la formule
print("")

print("")
print("----------------------------------------------------------")
print("")

let ex2 = (a || (c && a)) //formule exemple 2
print("ex2.")
print("formula: \(ex2)") //affichage de la formule
print("nnf    : \(ex2.nnf)") //affichage forme nnf de la formule
print("cnf    : \(ex2.cnf)") //affichage forme cnf de la formule
print("dnf    : \(ex2.dnf)") //affichage forme dnf de la formule

print("")
print("----------------------------------------------------------")
print("")

let ex3 = (!a || b && c) && a //formule exemple 3
print("ex3.")
print("formula: \(ex3)") //affichage de la formule
print("nnf    : \(ex3.nnf)") //affichage forme nnf de la formule
print("cnf    : \(ex3.cnf)") //affichage forme cnf de la formule
print("dnf    : \(ex3.dnf)") //affichage forme dnf de la formule
print("")

print("")
print("----------------------------------------------------------")
print("")

let ex4 = (!(a || (b && c))) => (b && (a || c)) //formule exemple 3
print("ex4.")
print("formula: \(ex4)") //affichage de la formule
print("nnf    : \(ex4.nnf)") //affichage forme nnf de la formule
print("cnf    : \(ex4.cnf)") //affichage forme cnf de la formule
print("dnf    : \(ex4.dnf)") //affichage forme dnf de la formule
print("")
