// Create a GuardModule instance for this guard NPC
guard = new GuardModule(x,y,noone, obj_protected_target, 2, 128, 64, 15, 3);
guard.killTarget = obj_enemy;
// Set an objective manually (optional)
//var obj_instance = instance_nearest(x, y, obj_protected_target); // Replace with actual objective instance

//if (instance_exists(obj_instance)) {
//    guard.SetObjective([obj_instance.x, obj_instance.y]);
//}

//guard.TargetNearest(obj_enemy);