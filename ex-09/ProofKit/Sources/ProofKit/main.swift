import ProofKitLib

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"

let ex1 = !(a && (b || c))
print("ex1.")
print("formula: \(ex1)")
print("nnf    : \(ex1.nnf)")
print("cnf    : \((!a || !b) && (!a || !c))")
print("dnf    : \(ex1.nnf)")
print("")

let ex2 = (a => b) || !(a && c)
print("ex2.")
print("formula: \(ex2)")
print("nnf    : \(ex2.nnf)")
print("cnf    : \((!a || b || !c))")
print("dnf    : \((!a || b || !c))")
print("")

let ex3 = (!a || b && c) && a
print("ex3.")
print("formula: \(ex3)")
print("nnf    : \(ex3.nnf)")
print("cnf    : \(b && c && a)")
print("dnf    : \(b && c && a)")
print("")
print("----------------------------------------------------------")
