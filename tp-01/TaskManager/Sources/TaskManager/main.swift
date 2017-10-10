import TaskManagerLib

let taskManager = createTaskManager()

// Show here an example of sequence that leads to the described problem.
// For instance:
//     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
//     let m2 = spawn.fire(from: m1!)ss
//     ...

  let create = taskManager.transitions.filter{$0.name == "create"}[0]
  let spawn = taskManager.transitions.filter{$0.name == "spawn"}[0]
  let exec = taskManager.transitions.filter{$0.name == "exec"}[0]
  let success = taskManager.transitions.filter{$0.name == "success"}[0]
  let fail = taskManager.transitions.filter{$0.name == "fail"}[0]


  let taskPool = taskManager.places.filter{$0.name == "taskPool"}[0]
  let processPool = taskManager.places.filter{$0.name == "processPool"}[0]
  let inProgress = taskManager.places.filter{$0.name == "inProgress"}[0]
  print("hello")

  let correctTaskManager = createCorrectTaskManager()

// Show here that you corrected the problem.
// For instance:
//     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
//     let m2 = spawn.fire(from: m1!)
//     ...
