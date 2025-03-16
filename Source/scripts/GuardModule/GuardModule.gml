/// GuardModule equivalent in GML

function GuardModule(_x, _y, _objective, _guardObjectiveTag, _objectiveSearchTime, _visionRange, _guardRange, _wanderInterval, _wanderWalkTime) constructor {
    static objective = _objective;
    static guardObjectiveTag = _guardObjectiveTag;
    static objectiveSearchTime = _objectiveSearchTime;
    static visionRange = _visionRange;
    static guardRange = _guardRange;
    static guardingRotation = 30.0;
    static rotationVariance = 15.0;
    static wanderInterval = _wanderInterval;
    static wanderWalkTime = _wanderWalkTime;
    static killTarget = noone;
    static wandering = false;
    static returning = false;
    static autoLookAround = true;
    static wander = true;
    static objectivePosition = [0, 0];
    static wanderCounter = wanderInterval;
    static hunting = false;
    static targetInView = false;
    static targetInViewLastFrame = false;
    static currentSearchTime = 0;
    static targetSearchTime = 0;
    static debug = true;
    static x = _x;
    static y = _y;
    static direction = 0;
    
    function OnEnable() {
        wandering = false;
        returning = false;
        wanderCounter = wanderInterval;
        objectivePosition = instance_exists(objective) ? [objective.x, objective.y] : [x, y];
        if (debug) show_debug_message("GuardModule Enabled at (" + string(x) + ", " + string(y) + ")");
    }

    function FixedUpdate() {
        wanderCounter -= delta_time;
        currentSearchTime -= delta_time;
        targetSearchTime -= delta_time;

        if (instance_exists(objective) && hunting == false) {
            objectivePosition = [objective.x, objective.y];
        } else if (currentSearchTime < 0 && guardObjectiveTag != "") {
            currentSearchTime = objectiveSearchTime;
            objective = instance_nearest(x, y, guardObjectiveTag);
            if (debug) show_debug_message("New Objective Found: " + string(objective));
        }

        UpdateTargetView();
        if (killTarget == noone && hunting == false) {
            hunting = false;
            UpdateWander();
        } else {
            UpdateAttack();
        }
		
		
		if (point_distance(x, y, objectivePosition[0], objectivePosition[1]) > 0) {
			var dir = [objectivePosition[0]-x,objectivePosition[1]-y];
			var dis = point_distance(x, y, objectivePosition[0], objectivePosition[1]) * 1.5;
			x+=dir[0]/dis;
			y+=dir[1]/dis;
		}
        targetInViewLastFrame = targetInView;
    }

    function UpdateTargetView() {
        if (instance_exists(killTarget) && point_distance(x, y, killTarget.x, killTarget.y) < visionRange) {
            targetInView = !collision_line(x, y, killTarget.x, killTarget.y, obj_obstruction, false, true);
			//if (debug) show_debug_message("Target In View: " + string(targetInView));
        } else {
            targetInView = false;
        }
    }

    function UpdateWander() {
		if (point_distance(x, y, objectivePosition[0], objectivePosition[1]) > guardRange) {
            StopWandering();
        }
        if (wanderCounter <= 0) {
            wanderCounter = wanderInterval;
            if (autoLookAround || wander) ChangeOrientation();
            if (wander) Wander();
        }
        if (debug) show_debug_message("Wander Counter: " + string(wanderCounter));
    }

    function UpdateAttack() {
		if (point_distance(objectivePosition[0], objectivePosition[1], objective.x, objective.y) > guardRange) {
            hunting = false;
        }
        if (targetSearchTime < 0 && instance_exists(killTarget) && distance_to_point(killTarget.x,killTarget.y) < visionRange ) {
            targetSearchTime = objectiveSearchTime;
            SetTarget(killTarget);
        }
        //if (debug) show_debug_message("Attack Target: " + string(killTarget));
    }

    function StopWandering() {
        wandering = false;
        returning = true;
        MoveTo(objectivePosition);
        if (debug) show_debug_message("Stopped Wandering. Returning to Objective Position");
    }

    function Hunt() { 
        hunting = true;
		SetTarget(killTarget);
        if (debug) show_debug_message("Hunting Enabled");
    }
    function StopHunting() { 
        hunting = false; 
        if (debug) show_debug_message("Hunting Disabled");
    }
    function Wander() {
        wandering = true;
        wanderCounter = wanderWalkTime;
        if (debug) show_debug_message("Started Wandering for " + string(wanderWalkTime) + " seconds");
    }

    function ChangeOrientation() {
        var _angle = guardingRotation + irandom_range(-rotationVariance, rotationVariance);
        direction += _angle;
        if (debug) show_debug_message("Changed Orientation: " + string(direction));
    }

    function SetTarget(_target) {
        if (instance_exists(_target)) {
            killTarget = _target;
            SetObjective([_target.x, _target.y]);
            if (debug) show_debug_message("New Target Set: " + string(killTarget));
        }
    }

    function ClearTarget() {
        killTarget = noone;
        StopWandering();
        if (debug) show_debug_message("Target Cleared");
    }

    function TargetNearest(_tag) {
        var _nearest = instance_nearest(x, y, _tag);
        if (instance_exists(_nearest)) SetTarget(_nearest);
        if (debug) show_debug_message("Targeting Nearest " + string(_tag));
    }

    function SetObjective(_position) { 
        objectivePosition = _position; 
        if (debug) show_debug_message("Objective Position Set: (" + string(objectivePosition[0]) + ", " + string(objectivePosition[1]) + ")");
    }
    function MoveTo(_position) { 
        SetObjective(_position); 
        if (debug) show_debug_message("Moving to Objective Position");
    }
}
