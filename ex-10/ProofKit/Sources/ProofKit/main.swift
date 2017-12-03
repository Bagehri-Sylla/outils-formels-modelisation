import ProofKitLib

/*
let b  : Formula = "b" //beau
let u  : Formula = "u" //universté
let p  : Formula = "p" //pluie
let m  : Formula = "m" //maison
let e  : Formula = "e" //exercice
let g  : Formula = "g" //ciel gris
let c  : Formula = "c" //relire cours
let con: Formula = "con" //on est content

let f = (b => u) && (p => !u) && (!m => u) && (m => (e && c)) && (g => p) && (u => (e && con)) && (b || g) |- e
print(f)
print("")
print(f.isProvable)
*/

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
let d: Formula = "d"

let j = (a || b) |- (a && c) || (b && c) || !c
print(j.isProvable)
print("")
print("------------------------------------------------------")
print("")

let k = (a => b) && (a => c) && (b => d) && (c => d) |- (a => d)
print(k.isProvable)
print("")
print("------------------------------------------------------")
print("")

let l = (a => b) && (b => a) |- (a => b) && (b => a)
print(l.isProvable)
print("")
print("------------------------------------------------------")
print("")


/*
print(f)

let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
print(booleanEvaluation)

enum Fruit: BooleanAlgebra {

    case apple, orange

    static prefix func !(operand: Fruit) -> Fruit {
        switch operand {
        case .apple : return .orange
        case .orange: return .apple
        }
    }

    static func ||(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.orange, .orange): return .orange
        case (_ , _)           : return .apple
        }
    }

    static func &&(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.apple , .apple): return .apple
        case (_, _)           : return .orange
        }
    }

}

let fruityEvaluation = f.eval { (proposition) -> Fruit in
    switch proposition {
        case "p": return .apple
        case "q": return .orange
        default : return .orange
    }
}
print(fruityEvaluation)
*/
