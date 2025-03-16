function AnimationCurve() constructor {
    // Create the animation curve asset
    static curve = animcurve_create();
    curve.name = "Custom_Curve";

    // Create the channel
    static channel = animcurve_channel_new();
    channel.name = "default";
    channel.type = animcurvetype_catmullrom;
    channel.iterations = 8;
    //channel.points = array_create(0);
	
	var _points = array_create(2);
	_points[0] = animcurve_point_new();
	_points[0].posx = 0;
	_points[0].value = 0;
	_points[1] = animcurve_point_new();
	_points[1].posx = 1;
	_points[1].value = 1;
	channel.points = _points;
	
    // Assign channel to curve
    curve.channels = [channel];

    /// Adds a keyframe to the animation curve
    function AddKey(_posx, _value) {
        var _point = animcurve_point_new();
        _point.posx = _posx;
        _point.value = _value;
        array_push(channel.points, _point);
		trace("Adding point to graph\n",channel.points);
    }

    /// Evaluates the curve at a given input value (Only if it has >= 2 keyframes)
    function Evaluate(_input) {
        if (array_length(self.channel.points) >= 2) {
            return animcurve_channel_evaluate(self.channel, _input);
        }
        return 0; // Not enough keyframes to evaluate
    }
	
	function keyLength() {
        return array_length(self.channel.points);
    }
	
    //AddKey(0, 0);
    //AddKey(1, 1);
}
