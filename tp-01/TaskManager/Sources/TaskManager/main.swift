import TaskManagerLib

//Exo 3
let taskManager = createTaskManager()

print("Exo 3: ici, on montre un exemple d'exécution qui conduit au problème spécifié dans la consigne")
print(" ")

  //Représentation des transitions du taskManager
  let create = taskManager.transitions.filter{$0.name == "create"}[0]
  let spawn = taskManager.transitions.filter{$0.name == "spawn"}[0]
  let exec = taskManager.transitions.filter{$0.name == "exec"}[0]
  let success = taskManager.transitions.filter{$0.name == "success"}[0]
  let fail = taskManager.transitions.filter{$0.name == "fail"}[0]

  //Représentation des places du taskManager
  let taskPool = taskManager.places.filter{$0.name == "taskPool"}[0]
  let processPool = taskManager.places.filter{$0.name == "processPool"}[0]
  let inProgress = taskManager.places.filter{$0.name == "inProgress"}[0]

//liste des fausse exécutions (Fexec1, Fexec2 ...) qui prouve qu'il y a un probleme dans ce réseau de Petri
  let Fexec1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
  print("exec1 (create) ", Fexec1!)

  let Fexec2 = spawn.fire(from: Fexec1!)
  print("exec2 (spawn)", Fexec2!)

  let Fexec3 = spawn.fire(from: Fexec2!)
  print("exec3 (spawn)", Fexec3!)

  let Fexec4 = exec.fire(from: Fexec3!)
  print("exec4 (exec)", Fexec4!)

  let Fexec5 = exec.fire(from: Fexec4!)
  print("exec5 (exec)", Fexec5!)

  let Fexec6 = success.fire(from: Fexec5!)
  print("exec6 (success)", Fexec6!)

  print(" ")

  print("Donc le soucis est qu'on a un jeton dans inProgress a l'exec6, et celui-ci ne peut que fail")
  print("Donc on aura plus de jeton dans taskPool, ce qui fait que sa ne fonctionne pas !")


  let correctTaskManager = createCorrectTaskManager()

  print(" ")
  print("_______________________________________________________________________________________________________")
  print(" ")
  print("Exo 4: ici, on montre une des solutions correcte qu'on peut apporter au probleme")
  print(" ")

  //Représentation des transitions du taskManager
  let create2 = correctTaskManager.transitions.filter{$0.name == "create"}[0]
  let spawn2 = correctTaskManager.transitions.filter{$0.name == "spawn"}[0]
  let exec2 = correctTaskManager.transitions.filter{$0.name == "exec"}[0]
  let success2 = correctTaskManager.transitions.filter{$0.name == "success"}[0]
  let fail2 = correctTaskManager.transitions.filter{$0.name == "fail"}[0]

  //Représentation des places du taskManager
  let taskPool2 = correctTaskManager.places.filter{$0.name == "taskPool"}[0]
  let processPool2 = correctTaskManager.places.filter{$0.name == "processPool"}[0]
  let inProgress2 = correctTaskManager.places.filter{$0.name == "inProgress"}[0]
  let assurance = correctTaskManager.places.filter{$0.name == "assurance"}[0]

  //liste des bonnes exécutions (Bexec1, Bexec2, ...) qui montre qu'on peut résoudre le pobleme avec cette méthode
  let Bexec1 = create2.fire(from: [taskPool2: 0, processPool2: 0, inProgress2: 0, assurance: 0])
  print("execution1 (create) ",Bexec1!)

  let Bexec2 = spawn2.fire(from: Bexec1!)
  print("execution2 (spawn) ", Bexec2!)

  let Bexec3 = spawn2.fire(from: Bexec2!)
  print("execution3 (spawn) ", Bexec3!)

  let Bexec4 = exec2.fire(from: Bexec3!)
  print("execution4 (exec) ", Bexec4!)

  let Bexec5 = success2.fire(from: Bexec4!)
  print("execution5 (success) ", Bexec5!)

  let Bexec6 = fail2.fire(from: Bexec4!)
  print("execution5 (fail) ", Bexec6!)

  //on corrige donc l'erreur en s'asurant bien qu'un processus est associé à une seul tâche 
