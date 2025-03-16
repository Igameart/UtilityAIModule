// Update guard behavior every frame
guard.FixedUpdate();

// If a target is found, make the guard hunt
if (guard.targetInView) {
    guard.Hunt();
}

// If no target, return to normal patrolling
if (!guard.targetInView && guard.hunting) {
    guard.StopHunting();
}
