/// @function Condition(_type, _stat, _value, _comparator)
/// @description Creates a new condition object.
/// @param {any} _type The type of condition.
/// @param {string} _stat The stat to check.
/// @param {any} _value The value to compare against.
/// @param {function} _comparator The comparison function.
function Condition(_type, _stat, _value, _comparator) constructor {
    type = _type;
    stat = _stat;
    value = _value;
    comparator = _comparator;
}

/// @function Effect(_name, _newValue)
/// @description Creates a new effect object.
/// @param {string} _name The name of the stat to modify.
/// @param {any} _newValue The new value to set.
function Effect(_name, _newValue) constructor {
    name = _name;
    newValue = _newValue;
}

/// @function Action(_name, _cost, _actionDelay, _conditions, _effects, _message, _satisfiesDirectives)
/// @description Creates a new action object.
/// @param {string} _name The name of the action.
/// @param {real} _cost The cost of the action.
/// @param {real} _actionDelay The delay before the action is executed.
/// @param {array<Condition>} _conditions An array of condition objects.
/// @param {array<Effect>} _effects An array of effect objects.
/// @param {function} _message The message function to execute.
/// @param {array<{directive:string, value:real}>} _satisfiesDirectives An array of directives satisfied by the action.
function Action(_name, _cost, _actionDelay, _conditions, _effects, _message, _satisfiesDirectives) constructor {
    name = _name;
    cost = _cost;
    actionDelay = _actionDelay;
    conditions = _conditions;
    effects = _effects;
    message = _message;
    satisfiesDirectives = _satisfiesDirectives;
}

/// @function BehaviorSequencer(_designator, _agent, _exclusive, _completionDelay, _loop)
/// @description Creates a new behavior sequencer object.
/// @param {string} _designator The designator of the sequencer.
/// @param {object} _agent The agent object.
/// @param {bool} _exclusive Whether the sequencer interrupts other sequencers.
/// @param {real} _completionDelay The delay before the sequence completes.
/// @param {bool} _loop Whether the sequence loops.
function BehaviorSequencer(_designator, _agent, _exclusive, _completionDelay, _loop) constructor {
    static designator = _designator;
    static agent = _agent;
    static exclusive = _exclusive;
    static completionDelay = _completionDelay;
    static loop = _loop;
    static sequence = [];
    static debug = true;
    static currentIndex = 0;
    static active = false;
    static time_sources = [];
    static currentAction = noone;

    /// @function StartSequence(_designator)
    /// @description Starts the sequence.
    /// @param {string} _designator The designator of the sequence to start.
    function StartSequence(_designator) {
        if (_designator != designator || active) return;
        if (exclusive) {
            InterruptAll();
        }
        var goalAction = DetermineGoalAction();
        if (goalAction != undefined) {
            sequence = FindBestSequence(goalAction);
        }
        trace("Best sequence found", sequence);
        currentIndex = 0;
        active = true;
        ExecuteNextAction(0);
    }

    /// @function ExecuteNextAction(delayOverride)
    /// @description Executes the next action in the sequence.
    /// @param {real} delayOverride An optional delay override.
    function ExecuteNextAction(delayOverride) {
        trace("ExecuteNextAction called", delayOverride);
        if (!active || currentIndex >= array_length(sequence)) {
            trace("Sequence completed or not active", {active, currentIndex, sequence});
            CompleteSequence();
            return;
        }
        trace("Taking next action", {currentIndex, sequence_length: array_length(sequence)});
        TakeAction(sequence[currentIndex], delayOverride);
    }

    /// @function CheckConditions(conditions)
    /// @description Checks if all conditions are met.
    /// @param {array<Condition>} conditions An array of condition objects.
    /// @returns {bool} True if all conditions are met, false otherwise.
    function CheckConditions(conditions) {
        for (var i = 0; i < array_length(conditions); i++) {
            var condition = conditions[i];
            var statValue = agent[$ condition.stat];
            if (!condition.comparator(statValue, condition.value)) {
                return false;
            }
        }
        return true;
    }

    /// @function ApplyEffects(effects)
    /// @description Applies the effects to the agent.
    /// @param {array<Effect>} effects An array of effect objects.
    function ApplyEffects(effects) {
        for (var i = 0; i < array_length(effects); i++) {
            var effect = effects[i];
            agent[$ effect.name] = effect.newValue;
        }
    }

    /// @function TakeAction(_action, delayOverride)
    /// @description Executes a specific action.
    /// @param {Action} _action The action object to execute.
    /// @param {real} delayOverride An optional delay override.
    function TakeAction(_action, delayOverride) {
        trace("TakeAction called", {_action, delayOverride});
        if (debug) show_debug_message("Executing Action: " + _action.name);
        if (!CheckConditions(_action.conditions)) {
            trace("Conditions not met for action: " + _action.name);
            if (debug) show_debug_message("Conditions not met for action: " + _action.name);
            return;
        }
        trace("All conditions met", _action.conditions);
        var actionDelay = (delayOverride > 0) ? delayOverride : _action.actionDelay;
        currentAction = _action;
        var ts = time_source_create(time_source_game, actionDelay, time_source_units_seconds, function() {
            trace("Time source callback called", currentAction);
            if (currentAction != noone) {
                var _msg = currentAction.message;
                with agent _msg();
                ApplyEffects(currentAction.effects);
                agent.ai_brain.SatisfyDirective(currentAction);
                currentIndex++;
                ExecuteNextAction(0);
            }
        });
        time_source_start(ts);
    }

    /// @function CompleteSequence()
    /// @description Completes the sequence.
    function CompleteSequence() {
        trace("CompleteSequence called");
        if (completionDelay > 0) {
            var ts = time_source_create(time_source_game, completionDelay, time_source_units_seconds, function() {
                trace("Completion delay callback called", {loop});
                if (loop) {
                    StartSequence(designator);
                } else {
                    active = false;
                }
            });
            time_source_start(ts);
        } else {
            if (loop) {
                StartSequence(designator);
            } else {
                active = false;
            }
        }
    }

    /// @function TakeSelectedAction(_selector)
    /// @description Takes a specific action from the sequence.
    /// @param {real} _selector The index of the action to take.
    function TakeSelectedAction(_selector) {
        trace("TakeSelectedAction called", _selector);
        if (_selector >= 0 && _selector < array_length(sequence)) {
            TakeAction(sequence[_selector], sequence[_selector].actionDelay);
        }
    }

    /// @function Interrupt(_designator)
    /// @description Interrupts the sequence.
    /// @param {string} _designator The designator of the sequence to interrupt.
    function Interrupt(_designator) {
        trace("Interrupt called", _designator);
        if (_designator != designator) return;
        active = false;
        currentIndex = -1;
        currentAction = noone;
        for (var i = 0; i < array_length(time_sources); i++) {
            if (time_sources[i] != undefined) {
                time_source_destroy(time_sources[i]);
                trace("Time source destroyed", i);
            }
        }
        time_sources = [];
    }

    /// @function InterruptAll()
    /// @description Interrupts all sequences.
    function InterruptAll() {
        trace("InterruptAll called");
        active = false;
        currentIndex = -1;
        currentAction = noone;
        for (var i = 0; i < array_length(time_sources); i++) {
            if (time_sources[i] != undefined) {
                time_source_destroy(time_sources[i]);
                trace("Time source destroyed", i);
            }
        }
        time_sources = [];
    }

    /// @function TraceActions(currentAction, currentSequence, visitedActions)
    /// @description Traces through actions to find a sequence.
    /// @param {Action} currentAction The current action being traced.
    /// @param {array<Action>} currentSequence The current sequence of actions.
    /// @param {ds_map} visitedActions A map of visited actions.
    /// @returns {array<array<Action>>} An array of possible sequences.
    function TraceActions(currentAction, currentSequence, visitedActions) {
        trace("TraceActions called", {currentAction: currentAction.name, currentSequence, visitedActions});

        var allConditionsMet = true;
        for (var i = 0; i < array_length(currentAction.conditions); i++) {
            var condition = currentAction.conditions[i];
            var statValue = agent[$ condition.stat];
            if (!condition.comparator(statValue, condition.value)) {
                allConditionsMet = false;
                trace("Current action condition not met", {condition: condition.stat, requiredValue: condition.value, currentValue: statValue});
                break;
            }
        }

        if (allConditionsMet) {
            trace("All current action conditions met", currentSequence);
            array_push(currentSequence, currentAction);
            return [currentSequence];
        }

        if (ds_map_exists(visitedActions, currentAction.name)) {
            trace("Action already visited", currentAction.name);
            return [];
        }

        ds_map_add(visitedActions, currentAction.name, true);

        var sequences = [];
        for (var i = 0; i < array_length(agent.actions); i++) {
            var action = agent.actions[i];
            for (var j = 0; j < array_length(action.effects); j++) {
                var effect = action.effects[j];
                if (effect.name == condition.stat && effect.newValue >= condition.value) {
                    trace("Effect satisfies condition", {effect, condition});
                    var newSequence = TraceActions(action, copy_array(currentSequence), visitedActions);
                    if (!is_undefined(newSequence) && array_length(newSequence) > 0) {
                        for (var k = 0; k < array_length(newSequence); k++) {
                            array_push(sequences, newSequence[k]);
                        }
                    }
                }
            }
        }

        ds_map_destroy(visitedActions);
        trace("Returning sequences", sequences);
        return array_length(sequences) > 0 ? sequences : [currentSequence];
    }

    /// @function FindBestSequence(goalAction)
    /// @description Finds the best sequence of actions to achieve a goal.
    /// @param {Action} goalAction The goal action.
    /// @returns {array<Action>} The best sequence of actions.
    function FindBestSequence(goalAction) {
        trace("FindBestSequence called", goalAction);
        var bestSequence = [];
        var lowestCost = infinity;

        var visitedActions = ds_map_create();
        var sequences = TraceActions(goalAction, [], visitedActions);
        ds_map_destroy(visitedActions);

        trace("Sequences found", sequences);

        for (var j = 0; j < array_length(sequences); j++) {
            var sequence = sequences[j];
            var totalCost = 0;
            for (var k = 0; k < array_length(sequence); k++) {
                totalCost += sequence[k].cost;
            }

            if (totalCost < lowestCost) {
                lowestCost = totalCost;
                bestSequence = sequence;
            }
        }

        trace("Best sequence determined", bestSequence);
        return bestSequence;
    }

    /// @function DetermineGoalAction()
    /// @description Determines the goal action based on directives.
    /// @returns {Action} The goal action.
    function DetermineGoalAction() {
        var highestValence = -1;
        var goalDirective = undefined;
        for (var i = 0; i < array_length(agent.ai_brain.directives); i++) {
            var directive = agent.ai_brain.directives[i];
            if (directive.valence > highestValence) {
                highestValence = directive.valence;
                goalDirective = directive;
            }
        }

        if (goalDirective != undefined) {
            var bestAction = undefined;
            var bestSatisfactionValue = -infinity;
            for (var i = 0; i < array_length(agent.actions); i++) {
                var action = agent.actions[i];
                for (var j = 0; j < array_length(action.satisfiesDirectives); j++) {
                    var directiveSatisfaction = action.satisfiesDirectives[j];
                    if (directiveSatisfaction.directive == goalDirective.name && directiveSatisfaction.value > bestSatisfactionValue) {
                        bestSatisfactionValue = directiveSatisfaction.value;
                        bestAction = action;
                    }
                }
            }
            return bestAction;
        }

        return undefined;
    }
}