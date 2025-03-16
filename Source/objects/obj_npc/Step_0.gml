// Update utility calculations every frame
utility_ai.Update();

// Decide which behavior to execute
utility_ai.Decide();

// If a new behavior is selected, execute the sequence
//if (utility_ai.currentSequence != -1) {
//    behavior_ai.StartSequence("AI_Sequencer");
//}
