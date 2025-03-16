/// @function UtilityModule(_agent)
/// @description Creates a new utility module for an agent.
/// @param {object} _agent The agent object.
function UtilityModule(_agent) constructor {
    static agent = _agent;
    static directives = [];
    static uniqueIdentifier = "";
    static personalityName = "";
    static nameDisplay = undefined;
    static currentSequence = -1;
    static highest = -1;
    static selector = "";
    static enabled = true;

    /// @function Directive(_name, _changePerSec, _desiredObject, _desiredCount, _satisfactionValue, _lockUntilSatisfied, _valence, _sequencer, _sequenceName)
    /// @description Creates a new directive object.
    /// @param {string} _name The name of the directive.
    /// @param {real} _changePerSec The change in valence per second.
    /// @param {object index} _desiredObject The desired object type.
    /// @param {real} _desiredCount The desired count of the object.
    /// @param {real} _satisfactionValue The satisfaction value.
    /// @param {bool} _lockUntilSatisfied Whether the directive locks until satisfied.
    /// @param {real} _valence The initial valence.
    /// @param {object} _sequencer The sequencer object.
    /// @param {string} _sequenceName The name of the sequence.
    function Directive(_name, _changePerSec, _desiredObject, _desiredCount, _satisfactionValue, _lockUntilSatisfied, _valence, _sequencer, _sequenceName) constructor {
        name = _name;
        changePerSec = _changePerSec;
        desiredObject = _desiredObject;
        desiredCount = _desiredCount;
        satisfactionValue = _satisfactionValue;
        lockUntilSatisfied = _lockUntilSatisfied;
        currentlyLocked = false;
        valence = _valence;
        sequencer = _sequencer;
        sequenceDesignator = _sequenceName;
        utilityGraph = new AnimationCurve();
        utilityDisplay = undefined;
        conditions = [];

        /// @function AddCondition(_stat, _value, _comparator)
        /// @description Adds a condition to the directive.
        /// @param {string} _stat The stat to check.
        /// @param {any} _value The value to compare against.
        /// @param {function} _comparator The comparison function.
        /// @returns {Condition} The created condition.
        function AddCondition(_stat, _value, _comparator) {
            var condition = new Condition("condition", _stat, _value, _comparator);
            array_push(conditions, condition);
            return condition;
        }
    }

    /// @function OnValidate()
    /// @description Validates the utility module.
    function OnValidate() {
        AdjustUtilities();
        if (uniqueIdentifier == "") {
            RandomizeIdentifier();
        }
        for (var i = 0; i < array_length(directives); i++) {
            var _dir = directives[i];
            if (_dir.utilityGraph.keyLength() <= 0) {
                _dir.utilityGraph.AddKey(0, 0);
                _dir.utilityGraph.AddKey(1, 1);
            }
            if (_dir.sequencer == undefined) {
                _dir.sequencer = self;
            }
        }
    }

    /// @function Awake()
    /// @description Placeholder awake function.
    function Awake() {
    }

    /// @function Start()
    /// @description Starts the utility module.
    function Start() {
        for (var i = 0; i < array_length(directives); i++) {
            var _dir = directives[i];
            if (_dir.utilityGraph.keyLength() <= 0) {
                _dir.utilityGraph.AddKey(0, 0);
                _dir.utilityGraph.AddKey(1, 1);
            }
            if (_dir.sequencer == undefined) {
                _dir.sequencer = self;
            }
            if (_dir.utilityDisplay != undefined) {
                _dir.utilityDisplay.value = _dir.utility;
            }
        }
    }

    /// @function Update()
    /// @description Updates the utility module.
    function Update() {
        AdjustUtilities();
        highest = FindHighestUtility();
        if (highest != -1) {
            if (highest != currentSequence) {
                if (currentSequence == -1 || !directives[highest].currentlyLocked) {
                    InitializeDirective(highest);
                }
            }
        }
        array_foreach(directives, function(_directive, _index) {
            if (_directive.utilityDisplay != undefined) {
                _directive.utilityDisplay.value = _directive.utility;
            }
        });
    }

    /// @function InitializeDirective(_index)
    /// @description Initializes a directive.
    /// @param {real} _index The index of the directive.
    function InitializeDirective(_index) {
        currentSequence = _index;
        for (var i = 0; i < array_length(directives); i++) {
            if (i == _index) {
                var _dir = directives[i];
                if (is_struct(_dir.sequencer)) {
                    var sequencer = _dir.sequencer;
                    sequencer.StartSequence(_dir.sequenceDesignator);
                }
                directives[i].startTime = current_time;
                if (directives[i].lockUntilSatisfied) {
                    directives[i].currentlyLocked = true;
                }
            } else {
                directives[i].startTime = -1;
            }
        }
    }

    /// @function AdjustUtilities()
    /// @description Adjusts the utilities of the directives.
    function AdjustUtilities() {
        for (var i = 0; i < array_length(directives); i++) {
            var _dir = directives[i];
            _dir.valence += _dir.changePerSec / 60;
            if (_dir.desiredObject != undefined) {
                var _desiredObjects = [];
                with (_dir.desiredObject) {
                    array_push(_desiredObjects, id);
                }
                if (_dir.desiredCount != 0) {
                    _dir.valence = clamp(abs(array_length(_desiredObjects) / _dir.desiredCount), 0, 1);
                } else {
                    _dir.valence = array_length(_desiredObjects) > 0 ? 1 : 0;
                }
            }
            _dir.valence = clamp(_dir.valence, 0, 1);
            _dir.utility = _dir.utilityGraph.Evaluate(_dir.valence);
            show_debug_message("Directive: " + _dir.name + " | Utility: " + string(_dir.utility));
        }
    }

    /// @function FindHighestUtility()
    /// @description Finds the directive with the highest utility.
    /// @returns {real} The index of the directive with the highest utility.
    function FindHighestUtility() {
        var ret = -1;
        var highestUtil = -1;
        for (var i = 0; i < array_length(directives); i++) {
            if (directives[i].utility > highestUtil) {
                highestUtil = directives[i].utility;
                ret = i;
            }
        }
        return ret;
    }

    /// @function SatisfyDirective(_directiveName, _value)
    /// @description Satisfies a directive.
    /// @param {string} _directiveName The name of the directive to satisfy.
    /// @param {real} _value Optional value to use instead of satisfactionValue.
    function SatisfyDirective(_directiveName, _value = undefined) {
        for (var i = 0; i < array_length(directives); i++) {
            var _dir = directives[i];
            if (_dir.name == _directiveName) {
                var _satisfy = _value == undefined ? _dir.satisfactionValue : _value;
                _dir.valence -= _satisfy;
                _dir.currentlyLocked = false;
                trace("Directive Satisfied:", _directiveName, _dir.valence);
            }
        }
    }

    /// @function FailDirective(_directiveName)
    /// @description Fails a directive.
    /// @param {string} _directiveName The name of the directive to fail.
    function FailDirective(_directiveName) {
        for (var i = 0; i < array_length(directives); i++) {
            var _dir = directives[i];
            if (_dir.name == _directiveName && currentSequence == i) {
                currentSequence = -1;
                if (_dir.failureSequence != "") {
                    if (instance_exists(_dir.sequencer)) {
                        var sequencer = _dir.sequencer;
                        sequencer.StartSequence(_dir.failureSequence);
                    }
                }
            }
        }
    }

    /// @function FailCurrentDirective()
    /// @description Fails the currently active directive.
    function FailCurrentDirective() {
        if (currentSequence >= 0) {
            for (var i = 0; i < array_length(directives); i++) {
                if (directives[i].sequenceDesignator == directives[currentSequence].sequenceDesignator) {
                    FailDirective(directives[i].name);
                    directives[i].currentlyLocked = false;
                }
            }
        }
    }

    /// @function SelectDirective(_selector)
    /// @description Selects a directive by name.
    /// @param {string} _selector The name of the directive to select.
    function SelectDirective(_selector) {
        selector = _selector;
    }

    /// @function SatisfySelected(_satisfaction)
    /// @description Satisfies the selected directive.
    /// @param {real} _satisfaction The satisfaction value.
    function SatisfySelected(_satisfaction) {
        for (var i = 0; i < array_length(directives); i++) {
            var _dir = directives[i];
            if (_dir.name == selector) {
                _dir.currentlyLocked = false;
                _dir.valence += _satisfaction;
            }
        }
    }

    /// @function Decide()
    /// @description Decides which directive to activate based on utility.
    function Decide() {
        if (!enabled) return;
        highest = FindHighestUtility();
        if (highest != -1) {
            InitializeDirective(highest);
        }
    }

    /// @function Save()
    /// @description Saves the utility module's data.
    function Save() {
        PlayerPrefs.SetString("Util_" + uniqueIdentifier + "_personalityName", personalityName);
        for (var i = 0; i < array_length(directives); i++) {
            PlayerPrefs.SetFloat("Util_" + uniqueIdentifier + "_" + i, directives[i].valence);
            PlayerPrefs.SetInt("Util_Locked_" + uniqueIdentifier + "_" + i, directives[i].currentlyLocked ? 1 : 0);
        }
    }

    /// @function Load()
    /// @description Loads the utility module's data.
    function Load() {
        if (!PlayerPrefs.HasKey("Util_" + uniqueIdentifier + "_" + 0)) return;
        if (PlayerPrefs.HasKey("Util_" + uniqueIdentifier + "_personalityName")) {
            personalityName = PlayerPrefs.GetString("Util_" + uniqueIdentifier + "_personalityName");
        }
        for (var i = 0; i < array_length(directives); i++) {
            directives[i].valence = PlayerPrefs.GetFloat("Util_" + uniqueIdentifier + "_" + i);
            directives[i].currentlyLocked = PlayerPrefs.GetInt("Util_Locked_" + uniqueIdentifier + "_" + i) == 1;
        }
    }

    /// @function RandomizeIdentifier()
    /// @description Generates a random unique identifier.
    function RandomizeIdentifier() {
        uniqueIdentifier = "";
        var _maxIterations = 100;
        var _currentIterations = 0;
        while (uniqueIdentifier == "") {
            var _rnd = irandom(100000);
            if (!PlayerPrefs.HasKey("Util_" + _rnd + "_" + 0)) {
                uniqueIdentifier = _rnd.toString();
            }
            _currentIterations++;
            if (_currentIterations >= _maxIterations) break;
        }
    }

    /// @function SetUniqueIdentifier(_identifier)
    /// @description Sets the unique identifier.
    /// @param {string} _identifier The identifier to set.
    function SetUniqueIdentifier(_identifier) {
        uniqueIdentifier = _identifier;
    }

    /// @function SetPersonalityName(_newName)
    /// @description Sets the personality name.
    /// @param {string} _newName The name to set.
    function SetPersonalityName(_newName) {
        personalityName = _newName;
        if (nameDisplay != undefined) {
            nameDisplay.text = personalityName;
        }
    }
}