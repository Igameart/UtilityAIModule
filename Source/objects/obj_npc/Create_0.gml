// AI Agent designed to manage its hunger, work, and sleep.

var agent = {
    strength: 10,
    intelligence: 5,
    hunger: 0.7,
    energy: 0.8,
    tiredness: 0.6,
    has_food: true,
    has_bed: true,
    is_awake: true,
    is_full: false,
    has_money: false,
    is_restored: false,
    actions: [],
    ai_brain: undefined
};

utility_ai = new UtilityModule(agent);
agent.ai_brain = utility_ai;

function MessageEat() {
    show_debug_message("AI is eating...");
    //with other{
	//	trace(self);
	//	ApplyEffects();
	//}
    ai_brain.SatisfyDirective("Eat");
}

function MessageWork() {
    show_debug_message("AI is working...");
    //with other ApplyEffects();
    ai_brain.SatisfyDirective("Work");
}

function MessageSleep() {
    show_debug_message("AI is sleeping...");
    //with other ApplyEffects();
    ai_brain.SatisfyDirective("Sleep");
}

behavior_eat = new BehaviorSequencer("Eating", agent, false, 0, true);
behavior_work = new BehaviorSequencer("Working", agent, false, 0, true);
behavior_sleep = new BehaviorSequencer("Sleeping", agent, false, 0, true);

var directive_eat = new utility_ai.Directive("Eat", 0.1, undefined, 0, 0.5, false, 0.7, behavior_eat, "Eating");

var directive_work = new utility_ai.Directive("Work", 0.1, undefined, 0, 0.5, false, 0.6, behavior_work, "Working");

var directive_sleep = new utility_ai.Directive("Sleep", 0.1, undefined, 0, 0.5, false, 0.5, behavior_sleep, "Sleeping");

array_push(utility_ai.directives, directive_eat);
array_push(utility_ai.directives, directive_work);
array_push(utility_ai.directives, directive_sleep);

var preconditions_eat = [
    new Condition("precondition", "hunger", 0.5, GreaterThanOrEqualTo)
];
var effects_eat = [
    new Effect("hunger", 0.1)
];

var preconditions_work = [
    new Condition("precondition", "energy", 0.3, GreaterThanOrEqualTo)
];
var effects_work = [
    new Effect("has_money", true)
];

var preconditions_sleep = [
    new Condition("precondition", "tiredness", 0.5, GreaterThanOrEqualTo)
];
var effects_sleep = [
    new Effect("tiredness", 0.1)
];

var action_eat = new Action("Eating", 10, 2, preconditions_eat, effects_eat, MessageEat, [{directive: "Eat", value: 0.8}]);
var action_work = new Action("Working", 20, 2, preconditions_work, effects_work, MessageWork, [{directive: "Work", value: 0.6}]);
var action_sleep = new Action("Sleeping", 15, 2, preconditions_sleep, effects_sleep, MessageSleep, [{directive: "Sleep", value: 0.7}]);

array_push(agent.actions, action_eat);
array_push(agent.actions, action_work);
array_push(agent.actions, action_sleep);

utility_ai.Start();